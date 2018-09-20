require "totem"

module Wasp
  class Configuration
    DEFAULT_FILENAME = "config.yml"

    def self.load_file(path : String = nil)
      new(path)
    end

    getter file : String

    @file : String
    @raw : Totem::Config

    def initialize(path : String? = nil)
      @file = find_file(path)
      raise NotFoundFileError.new("Not found config file.") unless File.exists?(@file)
      @raw = Totem.from_file(@file)
    end

    forward_missing_to @raw

    def app_info
      {
        "name":    Wasp::NAME,
        "version": Wasp::VERSION,
        "crystal": Crystal::VERSION,
      }
    end

    private def find_file(path)
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
      property timezone : String
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
