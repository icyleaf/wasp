class Wasp::FileSystem
  class FrontMatter
    WASP_DATE_FORMAT = "%Y-%m-%dT%H:%M:%S%:z"

    @inner : Hash(YAML::Any, YAML::Any)

    def self.parse(text : String)
      self.new(text)
    end

    def initialize(text : String)
      @inner = if text.empty?
                 {} of YAML::Any => YAML::Any
               else
                 begin
                   YAML.parse(text).as_h
                 rescue TypeCastError
                   raise FrontMatterParseError.new("can not parse front matter from yaml string")
                 end
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
      case object = @inner.fetch("tags", YAML::Any.new(""))
      when .as_s?
        [object]
      when .as_a?
        object
      else
        [] of YAML::Any
      end
    end

    def categories
      case object = @inner.fetch("categories", YAML::Any.new(""))
      when .as_s?
        [object]
      when .as_a?
        object
      else
        [] of YAML::Any
      end
    end

    def draft?
      @inner.fetch("draft", "false") == "true"
    end

    def as_h
      @inner.merge({
        "date"       => date,
        "tags"       => tags,
        "categories" => categories,
      })
    end

    macro method_missing(call)
      @inner.fetch({{ call.name.id.stringify }}, "")

      # TODO: i don't know why this not works
      # case object = @inner.fetch({{ call.name.id.stringify }}, "")
      # when Nil
      #   object.to_s
      # when String
      #   object.as(YAML::Any)
      # when Array
      #   puts {{ call.name.id.stringify }}
      #   puts object.class
      #   object.as(Array(YAML::Any))
      # when Hash
      #   object.as(Hash(YAML::Any, YAML::Any))
      # else
      #   object
      # end
    end
  end
end
