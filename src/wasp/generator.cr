require "./generator/*"

module Wasp
  class Generator
    getter context : Context

    @handlers : Array(Handler)

    def initialize(source_path : String, options = {} of String => String, handlers = [] of Handler)
      @context = Context.new source_path, options
      @handlers = default_handers.concat handlers
    end

    def run
      0.upto(@handlers.size - 2) { |i| @handlers[i].next = @handlers[i + 1] }
      @handlers.first.call @context
    end

    private def default_handers
      [Contents.new.as(Handler)]
    end
  end
end
