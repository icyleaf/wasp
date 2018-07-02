require "yaml"

module Wasp
  class Configuration
    DEFAULT_FILENAME = "config.yml"

    def self.load_file(path : String = nil)
      new(path)
    end

    def self.decode(raws : YAML::Any | Configuration, key : String, converter : _)
      raise ConfigDecodeError.new("Not found the key in configuration: #{key}") unless raws[key]?
      decode raws[key], converter
    end

    def self.decode(raws : YAML::Any | Configuration, converter : _)
      converter.from_yaml raws.to_yaml
    end

    getter file : String

    @file : String
    @data : YAML::Any

    def initialize(path : String? = nil)
      @file = file(path)
      raise NotFoundFileError.new("Not found config file.") unless File.exists?(@file)

      @data = YAML.parse(File.open(@file))
    end

    def []=(key, value)
      @data.as_h[key] = value
    end

    def [](key)
      @data.as_h[key]
    end

    def []?(key)
      @data.as_h[key]?
    end

    def fetch(key, default = nil)
      @data.as_h[key]? || default
    end

    forward_missing_to @data

    def app_info
      {
        "name":    Wasp::NAME,
        "version": Wasp::VERSION,
        "crystal": Crystal::VERSION,
      }
    end

    def to_json(json)
      @data.to_json(json)
    end

    private def file(path)
      if path
        if File.directory?(path.not_nil!)
          File.join(path.not_nil!, DEFAULT_FILENAME)
        else
          path.not_nil!
        end
      else
        DEFAULT_FILENAME
      end
    end

    struct SiteStruct
      include YAML::Serializable

      property title : String
      property subtitle : String
      property description : String
      property base_url : String
      property permalink : String
      property ugly_url : Bool
    end

    struct SocialStruct
      include YAML::Serializable

      property twitter : String
      property facebook : String
      property instagram : String
    end

    struct AppStruct
      property name : String = Wasp::NAME
      property version : String = Wasp::VERSION
      property crystal : String = Crystal::VERSION
    end
  end
end
