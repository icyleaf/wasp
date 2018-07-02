module Wasp
  class Generator
    class Context
      CONTENTS_PATH = "contents"
      LAYOUTS_PATH  = "layouts"
      PUBLIC_PATH   = "public"
      STATIC_PATH   = "static"

      property source_path : String
      property site_config : Configuration
      # property fs : FileSystem
      property pages : Array(FileSystem::ContentFile)

      def initialize(@source_path : String, options = {} of String => String)
        @site_config = load_and_merge_config(@source_path, options)
        @pages = pages
      end

      def app_info
        {
          "name"    => Wasp::NAME,
          "version" => Wasp::VERSION,
        }
      end

      def pages
        Array(FileSystem::ContentFile).new.tap do |files|
          Dir.glob(File.join(contents_path, "**", "*.md")).each do |file|
            files << FileSystem::ContentFile.new(file, @site_config)
          end
        end.sort_by(&.date).reverse
      end

      {% for method in @type.constants %}
        def {{ method.stringify.downcase.id }}
          path_to({{ method.id }})
        end
      {% end %}

      private def path_to(path)
        File.join(@source_path, path)
      end

      private def load_and_merge_config(source_path : String, options : Hash(String, String))
        config = Configuration.load_file(source_path)
        options.each do |k, v|
          config[YAML::Any.new(k)] = YAML::Any.new(v)
        end
        config
      end
    end
  end
end
