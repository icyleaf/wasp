require "markdown"
require "yaml"
require "ecr"

class Wasp::Template
  def initialize(@metadata : YAML::Any, @content : String, @path : String)

  end

  ECR.def_to_s "./docs/layouts/post.html.ecr"
end

class Wasp::Command
  class Build < GlobalOptions
    class Help
      caption "Build markdown to static files"
    end

    def run
      path = args.path? ? args.path : "."
      path = File.join(File.expand_path(path), "contents", "**", "*")

      Dir.glob(path).each do |f|
        next if File.extname(f) != ".md"
        puts "************\nRead markdown file: #{File.basename(f)} ... \n************\n"
        text : String = File.read(f)
        match_result = text.match(/^(---\s*\n.*?\n?)^(---\s*$\n?)/m)

        raise "No found metadata" if match_result.nil?

        metadata : String = match_result[0]
        text = text.gsub(metadata, "")

        yaml : YAML::Any = YAML.parse(metadata)
        content = Markdown.to_html(text)

        puts Wasp::Template.new(yaml, content, path)
      end
    end
  end
end
