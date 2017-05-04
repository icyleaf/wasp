require "./wasp/*"
require "./wasp/helpers/*"

exit if ENV.has_key?("WASP_SPEC_RUNNING")

if ARGV.size > 0
  args = if ARGV[0].includes?(" ")
           ARGV[0].split(" ") + ARGV[1..-1]
         else
           ARGV
         end

  Wasp::Command.run(args)
else
  Wasp::Command.run %w(--help)
end
