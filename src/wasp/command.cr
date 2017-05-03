require "cli"

module Wasp
  abstract class GlobalOptions < Cli::Command
    DEFAULT_CONFIG_PATH = "."
    DEFAULT_CONTENTS_PATH = "contents/"
    DEFAULT_PUBLIC_PATH = "public/"
    DEFAULT_ASSETS_PATH = "static/"

    DEFAULT_INDEX_FILE = "index.html"
    DEFAULT_LIST_FILE = "list.html"
    DEFAULT_SINGLE_FILE = "single.html"

    class Options
      string %w(-s --source), var: "string", desc: "the source path of site to read"
      string %w(-o --output), var: "string", desc: "the path of generate to write"
      bool "--verbose", default: false, desc: "verbose output"

      help
    end

    def run
      UI.instance.logger.level = Logger::DEBUG if args.verbose?
    end
  end

  class Command < Cli::Supercommand
    class Help
      title "Wasp is a tool of static site generator, used to build your site."
      header "Complete documentation is available at http://github.com/icyleaf/wasp/."
      footer "Use 'wasp [command] --help' for more information about a command."
    end

    class Options
      string "--path", var: "string", desc: "the root path of Wasp site"
      string "--output", var: "string", desc: "the root path of Wasp site"
      bool "--verbose", default: false, desc: "verbose output"

      help
    end
  end
end

require "./commands/*"
