require "file_utils"
require "markdown"
require "liquid"
require "yaml"

class Wasp::Command
  class Build < GlobalOptions
    class Help
      caption "Build markdown to static files"
    end

    class Options
      string %w(-b --baseURL), var: "string", desc: "hostname (and path) to the root, e.g. http://icyleaf.com/"
      help
    end

    def run
      super

      start_time = Time.now

      site_path = File.expand_path(args.source? ? args.source : DEFAULT_CONFIG_PATH)
      content_path = File.join(site_path, DEFAULT_CONTENTS_PATH)
      public_path = File.join(site_path, DEFAULT_PUBLIC_PATH)

      UI.verbose "Using config file: #{site_path}"
      UI.verbose "Generating static files to #{File.join(public_path, DEFAULT_PUBLIC_PATH)}"

      # step 1: create public directory if not exists.
      # step 2: clean previous old files if exist public directory
      # step 3: copy assets
      # step 4: for loop all content
      # step 5: generate each single post
      # step 6: generate homepage

      copy_assets(site_path)

      files = Array(NamedTuple(file_name: String, file_path: String, file_dir: String, file_output_name: String, file_output_path: String, context: Liquid::Context)).new

      site_params = YAML.parse(File.read(File.join(site_path, "config.yml"))).as_h
      site_params["base_url"] = args.baseURL if args.baseURL?
      site_params["base_url"] = "#{site_params["base_url"]}/" unless site_params["base_url"].to_s.ends_with?("/")

      Dir.glob(File.join(content_path, "**", "*")).each do |f|
        file_ext = ".md"
        next if File.extname(f) != file_ext

        file_name = File.basename(f)
        file_dir = File.dirname(f).gsub(content_path, "")

        text : String = File.read(f)
        match_result = text.match(/^(---\s*\n.*?\n?)^(---\s*$\n?)/m)

        raise "No found metadata" if match_result.nil?

        metadata : String = match_result[0]
        text = text.gsub(metadata, "")
        content = Markdown.to_html(text)

        page_params = YAML.parse(metadata).as_h

        file_output_name = page_params["slug"].to_s || File.basename(file_name, file_ext)
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

        FileUtils.mkdir_p(File.join(public_path, file_output_path))
        File.write(File.join(public_path, file_output_path, file_output_index), tpl.render(ctx))

        files << {
          "file_name" : file_name,
          "file_dir" : file_dir,
          "file_path" : f,
          "file_output_name" : file_output_name,
          "file_output_path" : File.join(file_output_path, file_output_index),
          "context": ctx,
        }

        UI.verbose("From '#{File.join(file_dir, file_name)}' to '#{File.join(file_output_path, file_output_index)}'")
      end

      file_index_path = File.join(site_path, "layouts", "index.html")
      file_index_content = File.open(file_index_path)
      file_index_tpl = Liquid::Template.parse(file_index_content)

      posts = [] of Hash(String, String)
      files.each do |file|
        file_ctx = file["context"]
        posts << {
          "title" => file_ctx["page"]["title"].as_s,
          "date" => file_ctx["page"]["date"].as_s,
          "content" => file_ctx["page"]["content"].as_s,
          "summary" => file_ctx["page"]["content"].as_s[0..250],
          "link" => "#{file_ctx["site"]["base_url"].as_s}post/#{file_ctx["page"]["slug"].as_s}",
        }
      end

      file_index_ctx = Liquid::Context.new
      file_index_ctx.set "site", site_params
      file_index_ctx.set "posts", posts

      File.write(File.join(site_path, DEFAULT_PUBLIC_PATH, "index.html"), file_index_tpl.render(file_index_ctx))

      UI.message("Total in #{(Time.now - start_time).total_milliseconds} ms")
    end

    private def copy_assets(site_path)
      public_path = File.join(site_path, DEFAULT_PUBLIC_PATH)

      FileUtils.rm_rf(public_path) if Dir.exists?(public_path)
      FileUtils.mkdir_p(public_path)

      asset_src = File.join(site_path, DEFAULT_ASSETS_PATH)
      asset_desc = File.join(public_path, DEFAULT_ASSETS_PATH)
      FileUtils.cp_r(asset_src, asset_desc)
    end
  end
end
