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
      start_time = Time.now
      super

      source_path = File.expand_path(args.source)

      # step 1: create public directory if not exists.
      # step 2: clean previous old files if exist public directory
      # step 3: copy assets
      # step 4: for loop all content
      # step 5: generate each single post
      # step 6: generate homepage

      generator_options = {} of String => String
      generator_options["base_url"] = args.baseURL if args.baseURL?

      generator = Wasp::Generator.new(args.source, generator_options)

      copy_assets(generator.source_path)

      UI.verbose "Using config file: #{generator.source_path}"
      UI.verbose "Generating static files to #{generator.public_path}"

      pages = generator.contents.map(&.as_h)
      generator.contents.each do |content|
        single_view = File.open(File.join(generator.layouts_path, "_default/single.html"))
        single_template = Liquid::Template.parse(single_view)

        single_ctx = Liquid::Context.new
        single_ctx.set "site", generator.site_config
        single_ctx.set "wasp", generator.app_info
        single_ctx.set "pages", pages
        single_ctx.set "page", content.as_h

        single_output_path = File.join(generator.public_path, content.permalink)

        FileUtils.mkdir_p(single_output_path)
        File.write(File.join(single_output_path, "index.html"), single_template.render(single_ctx))

        UI.verbose("Write to #{File.join(single_output_path, "index.html")}")
      end

      index_view = File.open(File.join(generator.source_path, "layouts", "index.html"))
      index_template = Liquid::Template.parse(index_view)

      index_ctx = Liquid::Context.new
      index_ctx.set "site", generator.site_config
      index_ctx.set "wasp", generator.app_info
      index_ctx.set "pages", pages

      File.write(File.join(generator.public_path, "index.html"), index_template.render(index_ctx))

      not_found_view = File.open(File.join(generator.source_path, "layouts", "404.html"))
      not_found_template = Liquid::Template.parse(not_found_view)

      File.write(File.join(generator.public_path, "404.html"), not_found_template.render(index_ctx))

      UI.message("Total in #{(Time.now - start_time).total_milliseconds} ms")
    end

    private def copy_assets(source_path)
      public_path = File.join(source_path, Wasp::Generator::DEFAULT_PUBLIC_PATH)

      FileUtils.rm_rf(public_path) if Dir.exists?(public_path)
      FileUtils.mkdir_p(public_path)

      asset_src = File.join(source_path, Wasp::Generator::DEFAULT_STATIC_PATH)
      asset_desc = File.join(public_path, Wasp::Generator::DEFAULT_STATIC_PATH)
      FileUtils.cp_r(asset_src, asset_desc)
    end
  end
end
