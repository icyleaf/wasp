require "uri"

module Wasp
  class StaticSiteHandler
    include HTTP::Handler

    @public_dir : String

    def initialize(public_dir : String, fallthrough = true)
      @public_dir = File.expand_path(public_dir)
      @fallthrough = !!fallthrough
    end

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
        context.response.content_type = mime_type(file_path)
        context.response.content_length = File.size(file_path)
        File.open(file_path) do |file|
          IO.copy(file, context.response)
        end
      else
        call_next(context)
      end
    end

    # given a full path of the request, returns the path
    # of the file that should be expanded at the public_dir
    protected def request_path(path : String) : String
      path
    end

    private def redirect_to(context, url)
      context.response.status_code = 302

      url = URI.escape(url) { |b| URI.unreserved?(b) || b != '/' }
      context.response.headers.add "Location", url
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