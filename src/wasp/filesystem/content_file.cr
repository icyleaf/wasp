require "markdown"
require "yaml"
require "uri"

module Wasp::FileSystem
  class ContentFile
    getter content

    @content : String

    FRONT_MATTER_REGEX = /^(---\s*\n.*?\n?)^(---\s*$\n?)/m

    def initialize(file : String, @site_config : Hash(YAML::Type, YAML::Type))
      @file = File.expand_path(file)
      @name = File.basename(@file)

      text = File.read(@file)
      if text =~ FRONT_MATTER_REGEX
        @front_matter = FrontMatter.new($1)
      else
        raise MissingFrontMatterError.new("Not found metadata in " + @file)
      end

      @content = Markdown.to_html(text.gsub(FRONT_MATTER_REGEX, ""))
    end

    def section
      sections = @file.split("/")
      start_index = sections.index("contents").not_nil!
      sections.delete_at(start_index + 1, (sections.size - start_index - 2)).join("/")
    end

    def filename
      @name.chomp(File.extname(@name))
    end

    def summary(limit = 300)
      # TODO: process to pure text
      @content[0..limit] + " »"
    end

    def link(ugly_url = "false")
      @site_config["ugly_url"] ||= ugly_url.to_s
      File.join(@site_config["base_url"].to_s, permalink(@site_config["ugly_url"]))
    end

    def permalink(ugly_url = "false")
      sections = [] of String
      @site_config.fetch("permalink", ":filename").to_s.split("/").each do |section|
        next if section.empty?

        sections << permalink_section(section).to_s
      end

      uri = sections.join("/")
      uri = uri + ".html" if ugly_url == "true"
      uri
    end

    macro method_missing(call)
      @front_matter.{{ call.name.id }}
    end

    def as_h
      @front_matter.as_h.merge({
        "summary"   => summary,
        "content"   => @content,
        "permalink" => permalink,
        "link"      => link,
      })
    end

    private def permalink_section(uri)
      return "" if !uri || uri.empty?

      case uri
      when ":year"
        @front_matter.date.year
      when ":month"
        @front_matter.date.month
      when ":day"
        @front_matter.date.day
      when ":title", ":slug"
        @front_matter.slug ? @front_matter.slug : URI.escape(@front_matter.title.downcase.gsub(" ", "-"))
      when ":section"
        section
      else
        # such as :filename or others
        filename
      end
    end
  end
end
