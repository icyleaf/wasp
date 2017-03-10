module Wasp
  class Helper
    def self.metadata(text) : Array
      metadata_regex = /^(---\s*\n.*?\n?)^(---\s*$\n?)/m
      metadata = {} of String => String
      if text =~ metadata_regex
        metadata = YAML.parse($1)
        text = text.gsub(metadata_regex, "")
      end

      return [metadata, text]
    end
  end
end