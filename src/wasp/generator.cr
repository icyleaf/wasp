require "./filesystem/*"
require "yaml"

module Wasp
  class Generator
    DEFAULT_CONTENTS_PATH = "contents"
    DEFAULT_LAYOUTS_PATH  = "layouts"
    DEFAULT_PUBLIC_PATH   = "public"
    DEFAULT_STATIC_PATH   = "static"

    getter source_path, site_config

    @site_config : Hash(String, YAML::Any)
    @files : Array(FileSystem::ContentFile)

    def initialize(source_path : String, options = {} of String => String)
      @source_path = File.expand_path(source_path)

      raise NotFoundFileError.new("Not found contents path: " + contents_path) unless Dir.exists?(contents_path)

      @site_config = load_and_merge_config(@source_path, options)
      @files = [] of FileSystem::ContentFile
    end

    def contents
      return @files if @files && !@files.empty?

      Dir.glob(File.join(contents_path, "**", "*.md")).each do |file|
        @files << FileSystem::ContentFile.new(file, @site_config)
      end

      @files
    end

    def app_info
      {
        "name":    Wasp::NAME,
        "version": Wasp::VERSION,
        "crystal": Crystal::VERSION,
      }
    end

    {% for method in @type.constants %}
      def {{ method.stringify.downcase.split("_")[1..-1].join("_").id }}
        path_to({{ method.id }})
      end
    {% end %}

    # private def default_options
    #   {
    #     "permalink" => ":year/:month/:title"
    #   }
    # end

    private def update_site_config(options)
      options.each do |key, value|
        next unless @site_config.has_key?(key)

        @site_config[key] = value
      end

      @site_config
    end

    private def path_to(path)
      File.join(@source_path, path)
    end

    private def load_and_merge_config(source_path : String, options : Hash(String, String))
      config = Configuration.load_file(source_path).as_h

      Hash(String, YAML::Any).new.tap do |obj|
        config.each do |k, v|
          obj[k.to_s] = v
        end

        options.each do |k, v|
          obj[k] = YAML::Any.new(v)
        end
      end
    end
  end
end
