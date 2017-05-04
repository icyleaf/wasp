require "./filesystem/*"

module Wasp
  class Generator
    DEFAULT_CONFIG_FILE = "config.yml"
    DEFAULT_CONTENTS_PATH = "contents"
    DEFAULT_PUBLIC_PATH = "public"
    DEFAULT_STATIC_PATH = "static"

    @site_config : Hash(YAML::Type, YAML::Type)
    @files : Array(FileSystem::ContentFile)

    def initialize(source_path : String, @options = {} of String => String)
      @source_path = File.expand_path(source_path)

      raise NotFoundFileError.new("Not found config file: " + config_file) unless File.exists?(config_file)
      raise NotFoundFileError.new("Not found contents path: " + contents_path) unless Dir.exists?(contents_path)

      @site_config = YAML.parse(File.read(config_file)).as_h

      @files = [] of FileSystem::ContentFile
    end

    def contents
      Dir.glob(File.join(contents_path, "**", "*.md")).each do |file|
        @files << FileSystem::ContentFile.new(file, @site_config, contents_path)
      end

      @files
    end

    {% for method in @type.constants %}
      def {{ method.stringify.downcase.split("_")[1..-1].join("_").id }}
        path_to({{ method.id }})
      end
    {% end %}

    private def default_options

    end

    private def path_to(path)
      File.join(@source_path, path)
    end

  end
end
