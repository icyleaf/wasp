ENV["WASP_SPEC_RUNNING"] = "true"

require "spec"
require "../src/wasp"
require "./wasp/filesystem/*"