require "bundler"
require "rspec/core/rake_task"
Bundler.setup :spec
RSpec::Core::RakeTask.new(:spec) do |spec|
  ENV["RACK_ENV"] = "spec"
  spec.pattern = ENV["SPECS"] || 'spec/**/**/*.spec.rb'
  spec.rspec_opts = "--format documentation"
end

