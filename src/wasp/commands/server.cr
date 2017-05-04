require "http/server"
require "../server/handlers/*"

class Wasp::Command
  class Server < GlobalOptions
    class Help
      caption "Run a web server"
    end

    class Options
      string %w(-b --baseURL), var: "string", default: "/", desc: "hostname (and path) to the root, e.g. http://icyleaf.com/"
      string "--bindHost", var: "string", default: "127.0.0.1", desc: "interface to which the server will bind"
      string "--watchInterval", var: "int", default: "1", desc: "seconds to wait between watch filesystem"
      string %w(-p --port), var: "int", default: "8624", desc: "port on which the server will listen"
      bool %w(-w --watch), not: "-W", default: true, desc: "watch filesystem for changes and recreate as needed"
      help
    end

    def run
      super

      # TODO: it does not works with localhost:8624 in HTTP::Server
      base_url = args.baseURL? ? args.baseURL : "/"
      build_args = ["--source", args.source, "--baseURL", base_url]
      Build.run(build_args)

      if args.watch?
        UI.verbose "Watch changes each #{args.watchInterval}s"
        watching_changes(args.source, build_args, args.watchInterval.to_i)
      end

      UI.message "Web Server is running at http://localhost:#{args.port}/ (bind address #{args.bindHost})"
      UI.message "Press Ctrl+C to stop"

      root_path = if args.source?
                    File.join(args.source, "public")
                  else
                    "public"
                  end

      server = HTTP::Server.new(args.bindHost, args.port.to_i, [
        HTTP::ErrorHandler.new,
        # HTTP::LogHandler.new,
        Wasp::StaticSiteHandler.new(root_path),
      ])

      server.listen
    end

    def watching_changes(source, build_args, watch_interval)
      watcher = Watcher.new(source)
      spawn do
        loop do
          watcher.watch_changes do |file, status|
            UI.message "File #{status}: #{file}"
            Build.run(build_args)
          end

          sleep watch_interval
        end
      end
    end
  end
end
