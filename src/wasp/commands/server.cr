require "http/server"

class Wasp::Command
  class Server < GlobalOptions
    class Help
      caption "Run a web server"
    end

    class Options
      string %w(-p --port), var: "int", default: "8624", desc: "port on which the server will listen"
      bool %w(-w --watch), default: true, desc: "watch filesystem for changes and recreate as needed"
      help
    end

    def run
      UI.message "Web Server is running at http://127.0.0.1:#{args.port} (Press Ctrl+C to stop)"

      server = HTTP::Server.new(args.port.to_i) do |context|
        context.response.content_type = "text/plain"
        context.response.print "Hello world, got #{context.request.path}!"
      end

      server.listen
    end
  end
end
