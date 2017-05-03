module Wasp::FileSystem
  class Metadata
    @metadata : Hash(YAML::Type, YAML::Type)

    def initialize(text : String)
      @metadata = YAML.parse(text).as_h
    end

    macro method_missing(call)
      case object = @metadata.fetch({{ call.name.id.stringify }}, "")
      when String
        object.to_s
      else
        object
      end
    end
  end
end