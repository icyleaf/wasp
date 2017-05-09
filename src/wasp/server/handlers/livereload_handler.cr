module Wasp
  class LiveReloadHandler < HTTP::WebSocketHandler
    def initialize(source_path : String, @port : Int32, &proc : String, Wasp::WatchFileStatus ->)
      @path = "/livereload"
      @source_path = File.expand_path(source_path)
      @watcher = Watcher.new(@source_path)

      @proc = ->(socket : HTTP::WebSocket, context : HTTP::Server::Context) do
        socket.on_message do |message|
          if message.includes?("\"command\":\"hello\"")
            socket.send({
              "command" => "hello",
              "protocols" => [
                "http://livereload.com/protocols/official-7"
              ],
              "serverName": "Wasp"
            }.to_json)
          end
        end

        # FIXME: block http server process
        refreash_when_changes(socket, proc)

        return nil
      end
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
                      File.join(@source_path, "public", "index.html")
                    else
                      File.join(@source_path, "public", request_path, "index.html")
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

    private def refreash_when_changes(socket, proc)
      @watcher.watching do |file, status|
        proc.call file, status
        socket.send({
          "command" => "reload",
          "path": file,
          "liveCSS": true
        }.to_json)
      end

      # spawn do
      #   loop do
      #     @watcher.watch_changes do |file, status|
      #       puts file
      #       proc.call file, status
      #       refresh_path(socket, file)
      #     end

      #     sleep 1
      #   end
      # end
    end
  end
end