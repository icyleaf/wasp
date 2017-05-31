require "uri"

module Wasp
  class StaticSiteHandler < HTTP::StaticFileHandler
    def call(context)
      unless context.request.method == "GET" || context.request.method == "HEAD"
        if @fallthrough
          call_next(context)
        else
          context.response.status_code = 405
          context.response.headers.add("Allow", "GET, HEAD")
        end
        return
      end

      original_path = context.request.path.not_nil!
      is_dir_path = original_path.ends_with? "/"
      request_path = self.request_path(URI.unescape(original_path))

      expanded_path = File.expand_path(request_path, "/")
      if is_dir_path && !expanded_path.ends_with? "/"
        expanded_path = "#{expanded_path}/"
      end
      is_dir_path = expanded_path.ends_with? "/"

      file_path = File.join(@public_dir, expanded_path)
      is_dir = Dir.exists? file_path

      if request_path != expanded_path || is_dir && !is_dir_path
        redirect_to context, "#{expanded_path}#{is_dir && !is_dir_path ? "/" : ""}"
        return
      end

      # File path cannot contains '\0' (NUL) because all filesystem I know
      # don't accept '\0' character as file name.
      if request_path.includes? '\0'
        context.response.status_code = 400
        return
      end

      if Dir.exists?(file_path)
        file_path = File.join(file_path, "index.html")
      end

      if File.exists?(file_path)
        html_response(context, file_path)
      elsif File.exists?(File.join(@public_dir, "404.html"))
        html_response(context, File.join(@public_dir, "404.html"))
      else
        call_next(context)
      end
    end

    private def html_response(context, html_file)
      context.response.content_type = mime_type(html_file)
      context.response.content_length = File.size(html_file)
      File.open(html_file) do |file|
        IO.copy(file, context.response)
      end
    end

    private def mime_type(path)
      case File.extname(path)
      when ".txt"          then "text/plain"
      when ".htm", ".html" then "text/html"
      when ".css"          then "text/css"
      when ".jpg", ".jpeg" then "image/jpeg"
      when ".gif"          then "image/gif"
      when ".png"          then "image/png"
      when ".js"           then "application/javascript"
      else                      "application/octet-stream"
      end
    end
  end
end
