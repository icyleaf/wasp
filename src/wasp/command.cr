require "cli"

module Wasp
  abstract class GlobalOptions < Cli::Command
    class Options
      string %w(-s --source), var: "string", default: ".", desc: "the source path of site to read"
      string %w(-o --output), var: "string", desc: "the path of generate to write"
      bool "--verbose", default: false, desc: "verbose output"
      bool "--verboseLog", default: false, desc: "verbose logging timestamp"

      help
    end

    def run
      UI.instance.logger.level = Logger::DEBUG if args.verbose?
      ENV["WASP_SHOW_TIMESTAMP"] = "true" if args.verboseLog?
    end
  end

  class Command < Cli::Supercommand
    class Help
      title "Wasp is a tool of static site generator, used to build your site."
      header "Complete documentation is available at http://github.com/icyleaf/wasp/."
      footer "Use 'wasp [command] --help' for more information about a command."
    end

    class Options
      string %w(-s --source), var: "string", desc: "the source path of site to read"
      string %w(-o --output), var: "string", desc: "the path of generate to write"
      bool "--verbose", default: false, desc: "verbose output"
      bool "--verboseLog", default: false, desc: "verbose logging timestamp"

      help
    end
  end
end

require "./commands/*"
