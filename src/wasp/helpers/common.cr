module Wasp::Helper
  def self.source_path(args)
    args.source? ? args.source : "."
  end

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
