module Wasp::FileSystem
  class Metadata
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
      Time.parse(@metadata.fetch("date", "1970-01-01T00:00:00+08:00").to_s, "%Y-%m-%dT%H:%M:%S%:z")
    end

    def slug
      @metadata.fetch("slug", "").to_s
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
