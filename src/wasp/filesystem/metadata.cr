module Wasp::FileSystem
  class Metadata
    @metadata : Hash(YAML::Type, YAML::Type)

    def initialize(text : String)
      @metadata = YAML.parse(text).as_h
    end

    def title
      @metadata.fetch("title", "")
    end

    def date
      @metadata.fetch("date", "1970-01-01T00:00:00+08:00")
    end

    def slug
      @metadata.fetch("slug", "")
    end

    def tags
      @metadata.fetch("tags", [] of String)
    end

    def categories
      @metadata.fetch("categories", [] of String)
    end

    def draft?
      @metadata.fetch("draft", "false") == "true"
    end

    macro method_missing(call)
      @metadata.fetch({{ call.name.id.stringify }}, "")
    end
  end
end