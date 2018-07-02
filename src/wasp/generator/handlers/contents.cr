require "file_utils"
require "liquid"

class Wasp::Generator
  class Contents
    include Handler

    PAGES = ["index.html", "404.html"]

    def call(context)
      generate_assets context
      generate_pages context

      call_next context
    end

    private def generate_assets(context)
      public_path = context.public_path

      source_static_path = context.static_path
      public_static_path = File.join public_path, Context::STATIC_PATH

      FileUtils.rm_rf(public_path) if Dir.exists?(public_path)
      FileUtils.mkdir_p public_path
      FileUtils.cp_r source_static_path, public_static_path
    end

    private def generate_pages(context)
      template_ctx = Liquid::Context.new
      template_ctx.set "site", context.site_config
      template_ctx.set "wasp", context.app_info
      template_ctx.set "pages", context.pages.map(&.as_h)

      PAGES.each do |page|
        source_file = File.join context.source_path, "layouts", page
        desc_file = File.join context.public_path, page
        generate_page source_file, desc_file, template_ctx
      end

      context.pages.each do |content|
        source_file = File.join(context.layouts_path, "_default/single.html")
        desc_file = File.join(context.public_path, content.permalink, "index.html")

        generate_page(source_file, desc_file, template_ctx) do |ctx|
          Terminal::UI.verbose("Write to #{desc_file}")

          ctx.set "page", content.as_h
          ctx
        end
      end
    end

    private def generate_page(source_file, desc_file, template_ctx)
      template = template_file source_file
      File.write desc_file, template.render(template_ctx)
    end

    private def generate_page(source_file, desc_file, template_ctx)
      template = template_file source_file
      template_ctx = yield template_ctx

      desc_path = File.dirname desc_file
      FileUtils.mkdir_p desc_path unless Dir.exists?(desc_path)

      File.write desc_file, template.render(template_ctx)
    end

    private def template_file(path)
      file = File.open(path)
      Liquid::Template.parse(file)
    end
  end
end
