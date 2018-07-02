module Wasp
  class Generator
    module Handler
      property next : Handler | Nil

      abstract def call(context : Wasp::Generator::Context)

      def call_next(context : Wasp::Generator::Context)
        if next_handler = @next
          next_handler.call context
        end
      end
    end
  end
end

require "./handlers/*"
