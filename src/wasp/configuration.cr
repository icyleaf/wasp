require "yaml"

module Wasp
  module Configuration
    DEFAULT_FILENAME = "config.yml"

    def self.load_file(path : String = nil)
      file = if path
               if File.directory?(path.not_nil!)
                 File.join(path.not_nil!, DEFAULT_FILENAME)
               else
                 path.not_nil!
               end
             else
               DEFAULT_FILENAME
             end

      raise NotFoundFileError.new("Not found config file.") unless File.exists?(file)

      File.open(file) do |io|
        return YAML.parse(io)
      end
    end

    def self.decode(raws : YAML::Any, key : String, converter : _)
      return nil unless raws[key]?
      decode raws[key], converter
    end

    def self.decode(raws : YAML::Any, converter : _)
      converter.from_yaml raws.to_yaml
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
