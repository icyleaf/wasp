require "markdown"
require "yaml"
require "ecr"

class Wasp::Template
  def initialize(@config : Wasp::Config, @content : String)
  end

  ECR.def_to_s "./docs/layouts/post.html"
end

class Wasp::Command
  class Build < GlobalOptions
    class Help
      caption "Build markdown to static files"
    end

    def run
      path = args.path? ? args.path : "."
      content_path = File.join(File.expand_path(path), "contents", "**", "*")

      Dir.glob(content_path).each do |f|
        next if File.extname(f) != ".md"
        UI.head("Read markdown file: #{File.basename(f)}")
        text : String = File.read(f)
        match_result = text.match(/^(---\s*\n.*?\n?)^(---\s*$\n?)/m)

        raise "No found metadata" if match_result.nil?

        metadata : String = match_result[0]
        text = text.gsub(metadata, "")

        content = Markdown.to_html(text)

        config = Wasp::Config.new(File.expand_path(path))
        config.page = YAML.parse(metadata)

        UI.head("markdown => html: #{File.basename(f)}")
        puts Wasp::Template.new(config, content)
      end
    end
  end
end
