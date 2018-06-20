require "./wasp/ext/*"
require "./wasp/*"

unless ENV.has_key?("WASP_SPEC_RUNNING")
  args = if ARGV.size > 0
           ARGV
         else
           %w(--help)
         end

  Wasp::Command.run args
end
