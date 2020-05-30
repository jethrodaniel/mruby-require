# frozen_string_literal: true

MRuby::Gem::Specification.new("mruby-require") do |spec|
  spec.license = "MIT"
  spec.author  = "Mark Delk <jethrodaniel@gmail.com>"
  spec.summary = "require/load for MRuby"
  # spec.version =

  spec.add_dependency "mruby-io"

  spec.add_test_dependency "mruby-print"
  spec.add_test_dependency "mruby-env"
end
