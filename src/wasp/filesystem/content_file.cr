require "yaml"

module Wasp::FileSystem
  class ContentFile
    getter contents_path, name, path, text, metadata

    @body : String

    METADATA_REGEX = /^(---\s*\n.*?\n?)^(---\s*$\n?)/m

    def initialize(path : String, @site_config : Hash(YAML::Type, YAML::Type), contents_path : String)
      @path = File.expand_path(path)
      @contents_path = contents_path.ends_with?("/") ? contents_path : contents_path + "/"
      @name = File.basename(@path)
      @text = File.read(@path)
      @body = @text.gsub(METADATA_REGEX, "")

      if text =~ METADATA_REGEX
        @metadata = Metadata.new($1)
      else
        raise MissingMetadataError.new("Not fount metadata in " + path)
      end
    end

    def summary(limit = 300)
      @text[0..limit] + " »"
    end

    # def date
    #   @
    # end

    def link(ugly_url = "false")
      @site_config["ugly_url"] ||= ugly_url.to_s
      File.join(@site_config["base_url"].to_s, permalink(@site_config["ugly_url"]))
    end

    def permalink(ugly_url = "false")
      permalink = @site_config.fetch("permalink", ":filename")
      segments = permalink.split("/")
      segments.each do |segment|

      end

      # File.join(permalink_path.join("/"), permalink_slug(ugly_url))
    end

    def permalink_path
      File.dirname(@path).gsub(@contents_path, "").split("/")
    end

    def permalink_slug(ugly_url = "false")
      slug = @metadata.slug.to_s
      unless slug
        slug = @name.chomp(File.extname(@name))
      end

      ugly_url == "true" ? slug + ".html" : slug
    end

    private def parse_permalink_segment(segment)
      case segment
      when ":filename"
        File.join(permalink_path.join("/"), permalink_slug(ugly_url))
      when ":year"
      when ":month"
      when "day"
      when "title"
    end
  end
end
