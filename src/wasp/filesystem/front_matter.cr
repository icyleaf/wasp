module Wasp::FileSystem
  class FrontMatter

    WASP_DATE_FORMAT = "%Y-%m-%dT%H:%M:%S%:z"

    def self.parse(text : String)
      self.new(text)
    end

    def initialize(text : String)
      @inner = if text.empty?
                    {} of YAML::Type => YAML::Type
                  else
                    YAML.parse(text).as_h
                  end
    end

    def title
      @inner.fetch("title", "").to_s
    end

    def date
      Time.parse(@inner.fetch("date", "1970-01-01T00:00:00+00:00").to_s, WASP_DATE_FORMAT)
    end

    def slug
      @inner.fetch("slug", "").to_s
    end

    def tags
      case object = @inner.fetch("tags", "")
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
      case object = @inner.fetch("categories", "")
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
      @inner.fetch("draft", "false") == "true"
    end

    def as_h
      @inner.merge({
        "date" => date,
        "tags" => tags,
        "categories" => categories
      })
    end

    macro method_missing(call)
      @inner.fetch({{ call.name.id.stringify }}, "")

      # TODO: i don't know why this not works
      # case object = @inner.fetch({{ call.name.id.stringify }}, "")
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
