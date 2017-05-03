require "yaml"

module Wasp::FileSystem
  class ContentFile
    getter contents_path, name, path, text, metadata
    getter store_path, store_name

    @body : String

    METADATA_REGEX = /^(---\s*\n.*?\n?)^(---\s*$\n?)/m

    def initialize(path : String, contents_path : String, store_path = "public")
      @path = File.expand_path(path)
      @contents_path = contents_path.ends_with?("/") ? contents_path : contents_path + "/"
      @store_path = File.expand_path(store_path)
      @name = File.basename(@path)
      @text = File.read(@path)
      @body = @text.gsub(METADATA_REGEX, "")

      if text =~ METADATA_REGEX
        @metadata = Metadata.new($1)
      else
        raise MissingMetadataError.new("Not fount metadata in " + path)
      end
    end

    def permalink(ugly_url = false) : String
      File.join(permalink_path.join("/"), permalink_title(ugly_url))
    end

    def permalink_path : Array(String)
      File.dirname(@path).gsub(@contents_path, "").split("/")
    end

    def permalink_title(ugly_url = false)  : String
      title = @metadata.try_fetch("slug")
      unless title
        title = @name.chomp(File.extname(@name))
      end

      ugly_url ? title.to_s + ".html" : title.to_s
    end

    # protected def parse_metadata
    #   return @metadata if @metadata && !@metadata.empty?

    #   if @text =~ METADATA_REGEX
    #     @metadata = YAML.parse($1).as_h
    #   end

    #   @metadata
    # end
  end
end
