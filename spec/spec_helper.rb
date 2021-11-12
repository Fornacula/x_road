require 'bundler/setup'
Bundler.setup
require 'x_road'

RSpec.configure do |config|
  config.expect_with(:rspec) { |c| c.syntax = :expect }
end
