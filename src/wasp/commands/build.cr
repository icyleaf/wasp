require "file_utils"
require "liquid"
require "yaml"

module Wasp
  class Command < Cli::Supercommand
    command "b", aliased: "build"

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

        Terminal::UI.verbose "Using config file: #{generator.source_path}"
        Terminal::UI.verbose "Generating static files to #{generator.public_path}"

        pages = generator.contents.sort_by(&.date).reverse.map(&.as_h)

        global_ctx = Liquid::Context.new
        global_ctx.set "site", generator.site_config
        global_ctx.set "wasp", generator.app_info
        global_ctx.set "pages", pages

        write_template(File.join(generator.source_path, "layouts", "index.html"), File.join(generator.public_path, "index.html"), global_ctx)
        write_template(File.join(generator.source_path, "layouts", "404.html"), File.join(generator.public_path, "404.html"), global_ctx)

        generator.contents.each do |content|
          single_template = template_file(File.join(generator.layouts_path, "_default/single.html"))
          global_ctx.set "page", content.as_h

          single_output_path = File.join(generator.public_path, content.permalink)

          FileUtils.mkdir_p(single_output_path)
          File.write(File.join(single_output_path, "index.html"), single_template.render(global_ctx))

          Terminal::UI.verbose("Write to #{File.join(single_output_path, "index.html")}")
        end

        Terminal::UI.message("Total in #{(Time.now - start_time).total_milliseconds} ms")
      end

      private def copy_assets(source_path)
        public_path = File.join(source_path, Wasp::Generator::DEFAULT_PUBLIC_PATH)

        FileUtils.rm_rf(public_path) if Dir.exists?(public_path)
        FileUtils.mkdir_p(public_path)

        asset_src = File.join(source_path, Wasp::Generator::DEFAULT_STATIC_PATH)
        asset_desc = File.join(public_path, Wasp::Generator::DEFAULT_STATIC_PATH)
        FileUtils.cp_r(asset_src, asset_desc)
      end

      private def template_file(path)
        file = File.open(path)
        Liquid::Template.parse(file)
      end

      private def write_template(source_path, desc_path, context)
        template = template_file(source_path)
        File.write(desc_path, template.render(context))
      end
    end
  end
end
