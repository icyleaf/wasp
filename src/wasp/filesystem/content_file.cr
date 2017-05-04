require "yaml"

module Wasp::FileSystem
  class ContentFile
    getter contents_path, name, path, body

    @body : String

    METADATA_REGEX = /^(---\s*\n.*?\n?)^(---\s*$\n?)/m

    def initialize(path : String, @site_config : Hash(YAML::Type, YAML::Type), contents_path : String)
      @path = File.expand_path(path)
      @contents_path = contents_path.ends_with?("/") ? contents_path : contents_path + "/"
      @name = File.basename(@path)

      text = File.read(@path)
      if text =~ METADATA_REGEX
        @metadata = Metadata.new($1)
      else
        raise MissingMetadataError.new("Not fount metadata in " + path)
      end

      @body = text.gsub(METADATA_REGEX, "")
    end

    def summary(limit = 300)
      @body[0..limit] + " »"
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
      @metadata.{{ call.name.id }}
    end

    private def permalink_section(section)
      return "" if !section || section.empty?

      case section
      when ":year"
        @metadata.date.year
      when ":month"
        @metadata.date.month
      when ":day"
        @metadata.date.day
      when ":title"
        @metadata.title.downcase.gsub(" ", "-")
      when ":slug"
        @metadata.slug ? @metadata.slug : @metadata.title
      when ":section"
        File.dirname(@path).gsub(@contents_path, "")
      else
        # such as :filename or others
        @name.chomp(File.extname(@name))
      end
    end
  end
end
