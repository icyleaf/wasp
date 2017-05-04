module Wasp::FileSystem
  class Metadata

    WASP_DATE_FORMAT = "%Y-%m-%dT%H:%M:%S%:z"

    def self.parse(text : String)
      self.new(text)
    end

    def initialize(text : String)
      @metadata = if text.empty?
                    {} of YAML::Type => YAML::Type
                  else
                    YAML.parse(text).as_h
                  end
    end

    def title
      @metadata.fetch("title", "").to_s
    end

    def date
      Time.parse(@metadata.fetch("date", "1970-01-01T00:00:00+08:00").to_s, WASP_DATE_FORMAT)
    end

    def slug
      @metadata.fetch("slug", "").to_s
    end

    def tags
      case object = @metadata.fetch("tags", "")
      when String
        if object.to_s.empty?
          [] of YAML::Type
        else
          [ object.as(YAML::Type) ]
        end
      when Array
        object
      else
        raise Error.new("tags only accepts String and Array not #{object.class.name}")
      end
    end

    def categories
      case object = @metadata.fetch("categories", "")
      when String
        if object.to_s.empty?
          [] of YAML::Type
        else
          [ object.as(YAML::Type) ]
        end
      when Array
        object
      else
        raise Error.new("categories only accepts String and Array not #{object.class.name}")
      end
    end

    def draft?
      @metadata.fetch("draft", "false") == "true"
    end

    def as_h
      @metadata.merge({
        "date" => date,
        "tags" => tags,
        "categories" => categories
      })
    end

    macro method_missing(call)
      @metadata.fetch({{ call.name.id.stringify }}, "")

      # TODO: i don't know why this not works
      # case object = @metadata.fetch({{ call.name.id.stringify }}, "")
      # when Nil
      #   object.to_s
      # when String
      #   object.as(YAML::Type)
      # when Array
      #   puts {{ call.name.id.stringify }}
      #   puts object.class
      #   object.as(Array(YAML::Type))
      # when Hash
      #   object.as(Hash(YAML::Type, YAML::Type))
      # else
      #   object
      # end
    end
  end
end
