require "./filesystem/*"

module Wasp
  class Generator
    DEFAULT_CONFIG_FILE   = "config.yml"
    DEFAULT_CONTENTS_PATH = "contents"
    DEFAULT_LAYOUTS_PATH = "layouts"
    DEFAULT_PUBLIC_PATH   = "public"
    DEFAULT_STATIC_PATH   = "static"

    getter source_path, site_config

    @site_config : Hash(YAML::Type, YAML::Type)
    @files : Array(FileSystem::ContentFile)

    def initialize(source_path : String, options = {} of String => String)
      @source_path = File.expand_path(source_path)

      raise NotFoundFileError.new("Not found config file: " + config_file) unless File.exists?(config_file)
      raise NotFoundFileError.new("Not found contents path: " + contents_path) unless Dir.exists?(contents_path)

      @site_config = YAML.parse(File.read(config_file)).as_h
      @site_config.merge!(options)

      @files = [] of FileSystem::ContentFile
    end

    def contents
      return @files if @files && !@files.empty?

      Dir.glob(File.join(contents_path, "**", "*.md")).each do |file|
        @files << FileSystem::ContentFile.new(file, @site_config)
      end

      @files
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
  end
end
