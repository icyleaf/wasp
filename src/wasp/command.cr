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
      string "--path", var: "PATH", desc: "the root path of Wasp site"
      string "--output", var: "PATH", desc: "the root path of Wasp site"
      help
    end

    def run
      super
    rescue e: Wasp::Error
      UI.error(e.to_s)
    end
  end

  class Command < Cli::Supercommand
    class Help
      title "Wasp is a tool of static site generator, used to build your site."
      header "Complete documentation is available at http://github.com/icyleaf/wasp/."
      footer "Use 'wasp [command] --help' for more information about a command."
    end

    class Options
      string "--path", var: "PATH", desc: "the root path of Wasp site"
      string "--output", var: "PATH", desc: "the root path of Wasp site"
      help
    end
  end
end

require "./commands/*"
