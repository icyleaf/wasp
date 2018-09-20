require "./front_matter"
require "markd"
require "uri"

class Wasp::FileSystem
  struct ContentFile
    getter content

    @content : String

    FRONT_MATTER_REGEX = /^(---\s*\n.*?\n?)^(---\s*$\n?)/m

    def initialize(file : String, @site_config : Configuration)
      @file = File.expand_path(file)
      @name = File.basename(@file)

      text = File.read(@file)
      if text =~ FRONT_MATTER_REGEX
        @front_matter = FrontMatter.new($1, @site_config["timezone"].as_s)
      else
        raise MissingFrontMatterError.new("Not found metadata in " + @file)
      end

      @content = Markd.to_html(text.gsub(FRONT_MATTER_REGEX, ""))
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
      ugly_url = @site_config["ugly_url"]? || ugly_url.to_s
      File.join(@site_config["base_url"].to_s, permalink(ugly_url))
    end

    def permalink(ugly_url = "false")
      sections = [] of String
      (@site_config["permalink"]? || ":filename").to_s.split("/").each do |section|
        next if section.empty?

        sections << permalink_section(section).to_s
      end

      uri = sections.join("/")
      uri = uri + ".html" if ugly_url == "true"
      uri
    end

    forward_missing_to @front_matter

    def to_h
      @front_matter.to_h.merge({
        "summary"   => Totem::Any.new(summary),
        "content"   => Totem::Any.new(@content),
        "permalink" => Totem::Any.new(permalink),
        "link"      => Totem::Any.new(link),
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
