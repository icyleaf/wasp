require "file_utils"
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
        elapsed_time do
          options = Hash(String, String).new.tap do |obj|
            obj["base_url"] = args.baseURL if args.baseURL?
          end

          generator = Wasp::Generator.new args.source, options
          Terminal::UI.verbose "Using config file: #{generator.context.source_path}/config.yml"
          Terminal::UI.verbose "Generating static files to #{generator.context.public_path}"
          generator.run
        end
      end

      private def elapsed_time
        started_at = Time.now
        yield
        Terminal::UI.message("Total in #{(Time.now - started_at).total_milliseconds} ms")
      end
    end
  end
end
