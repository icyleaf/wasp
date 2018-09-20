require "file_utils"
require "crinja"

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
      template_env = Crinja.new
      template_env.loader = Crinja::Loader::FileSystemLoader.new(context.layouts_path)

      variables = {
        "site"  => context.site_config.to_h,
        "wasp"  => context.app_info,
        "pages" => context.pages.map(&.to_h),
      }

      PAGES.each do |page|
        desc_file = File.join context.public_path, page
        generate_page page, desc_file, template_env, variables
      end

      context.pages.each do |content|
        source_file = "_default/single.html"
        desc_file = File.join(context.public_path, content.permalink, "index.html")

        generate_page(source_file, desc_file, template_env, variables) do |variables|
          Terminal::UI.verbose("Write to #{desc_file}")

          variables["page"] = content.to_h
          variables
        end
      end
    end

    private def generate_page(source_file, desc_file, template_env, variables)
      template = template_env.get_template source_file
      File.write desc_file, template.render(variables)
    end

    private def generate_page(source_file, desc_file, template_env, variables)
      template = template_env.get_template source_file
      variables = yield variables

      desc_path = File.dirname desc_file
      FileUtils.mkdir_p desc_path unless Dir.exists?(desc_path)

      File.write desc_file, template.render(variables)
    end

    private def template_file(path)
      file = File.open(path)
      Liquid::Template.parse(file)
    end
  end
end
