require "./wasp/*"
require "./wasp/core_ext/*"
require "./wasp/helpers/*"

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