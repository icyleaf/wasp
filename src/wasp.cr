require "./wasp/*"
require "./wasp/helpers/*"
#
# if ARGV.size > 0
#   Wasp::Command.run ARGV
# else
#   Wasp::Command.run %w(--help)
# end
#
args = %w(build --path docs)
Wasp::Command.run args
