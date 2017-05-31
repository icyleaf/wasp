module Wasp
  class LiveReloadHandler < HTTP::WebSocketHandler
    def initialize(public_path : String, @port : Int32, &@proc : HTTP::WebSocket, HTTP::Server::Context ->)
      @path = "/livereload"
      @public_path = File.expand_path(public_path)
      # @watcher = Watcher.new()

      # proc = ->(socket : HTTP::WebSocket, HTTP::Server::Context ->) {
      #   puts typeof(socket)

      #   # watch_changes(socket)

      #   # socket.on_close do
      #   #   puts "Server: Closing socket"
      #   # end
      # }

      # sssproc = ->(){}
      # super(@path, )
    end

    def call(context)
      original_path = context.request.path.not_nil!
      is_dir_path = original_path.ends_with?("/")
      request_path = URI.unescape(original_path)

      # Load livereload js
      if request_path == "/livereload.js"
        js_file = File.expand_path("../../static/livereload.js", __FILE__)
        return File.open(js_file) do |file|
          IO.copy(file, context.response)
        end
      end

      # inject <script> tag to the bottom of html page
      if is_dir_path
        file_path = if request_path == "/"
                      File.join(@public_path, "index.html")
                    else
                      File.join(@public_path, request_path, "index.html")
                    end

        end_body_tag = "</body>"
        liverelaod_template = "<script data-no-instant>document.write('<script src=\"/livereload.js?port=#{@port.to_s}&snipver=1\"></' + 'script>')</script>\n</body>"

        content = File.read(file_path)
        context.response.content_type = "text/html"
        context.response.content_length = File.size(file_path)
        return context.response.print content.gsub(end_body_tag, liverelaod_template)
      end

      return call_next(context) unless context.request.path.not_nil! == @path
      super
    end

    private def refresh_path(socket, file)
      Wasp::Command::Build.run(@build_args)

      socket.send({
        "command" => "reload",
        "path":      file,
        "liveCSS":   true,
      }.to_json)
    end

    private def watch_changes(socket)
      spawn do
        loop do
          @watcher.watch_changes do |file, status|
            refresh_path(socket, file)
          end

          sleep 1
        end
      end
    end
  end
end
