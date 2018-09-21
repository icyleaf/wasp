require "totem"

module Wasp
  class Configuration
    include Totem::ConfigBuilder

    build do
      config_type "yaml"
    end

    def app_info
      {
        "name":    Wasp::NAME,
        "version": Wasp::VERSION,
        "crystal": Crystal::VERSION,
      }
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
