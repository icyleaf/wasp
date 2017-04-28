require "markdown"
require "yaml"
require "liquid"
require "file_utils"

class Wasp::Command
  class Build < GlobalOptions
    class Help
      caption "Build markdown to static files"
    end

    private def copy_assets(site_path)
      public_path = File.join(site_path, DEFAULT_PUBLIC_PATH)
      FileUtils.rm_rf(public_path) if Dir.exists?(public_path)
      FileUtils.mkdir_p(public_path)

      asset_src = File.join(site_path, DEFAULT_ASSETS_PATH)
      asset_desc = File.join(public_path, DEFAULT_ASSETS_PATH)
      FileUtils.cp_r(asset_src, asset_desc)
    end

    def run
      site_path = File.expand_path(args.path? ? args.path : DEFAULT_CONFIG_PATH)
      content_path = File.join(site_path, DEFAULT_CONTENTS_PATH)

      # step 1: create public directory if not exists.
      # step 2: clean previous old files if exist public directory
      # step 3: copy assets
      # step 4: for loop all content
      # step 5: generate each single post
      # step 6: generate homepage

      copy_assets(site_path)

      files = Array(NamedTuple(file_name: String, file_path: String, file_dir: String, file_output_name: String, file_output_path: String, context: Liquid::Context)).new

      Dir.glob(File.join(content_path, "**", "*")).each do |f|
        file_ext = ".md"
        next if File.extname(f) != file_ext

        file_name = File.basename(f)
        file_dir = File.dirname(f).gsub(content_path, "")

        UI.message("Read markdown: #{file_name}")

        text : String = File.read(f)
        match_result = text.match(/^(---\s*\n.*?\n?)^(---\s*$\n?)/m)

        raise "No found metadata" if match_result.nil?

        metadata : String = match_result[0]
        text = text.gsub(metadata, "")
        content = Markdown.to_html(text)

        site_params = YAML.parse(File.read(File.join(site_path, "config.yml"))).as_h
        page_params = YAML.parse(metadata).as_h

        file_output_name = page_params["permalink"].to_s || File.basename(file_name, file_ext)
        file_output_url = File.join(file_dir, file_output_name)
        file_output_path = File.join(file_dir, file_output_name)
        file_output_index = "index.html"

        page_params["url"] = file_output_url
        page_params["content"] = content

        ctx = Liquid::Context.new
        ctx.set "site", site_params
        ctx.set "page", page_params

        tpl_file = File.open(File.join(site_path, "layouts/post.html"))
        tpl = Liquid::Template.parse(tpl_file)

        UI.message("Write html: #{File.join(file_output_path, file_output_index)}")
        FileUtils.mkdir_p(File.join(site_path, DEFAULT_PUBLIC_PATH, file_output_path))
        File.write(File.join(site_path, DEFAULT_PUBLIC_PATH, file_output_path, file_output_index), tpl.render(ctx))

        files << {
          "file_name" : file_name,
          "file_dir" : file_dir,
          "file_path" : f,
          "file_output_name" : file_output_name,
          "file_output_path" : File.join(file_output_path, file_output_index),
          "context": ctx,
        }
      end

      # index_ctx = Liquid::Context.new
      # files.each do |item|
      #
      # end

      pp files
    end
  end
end
