require "bundler/setup"
require "minitest/autorun"
require "mocha/setup"

Dir[File.expand_path('../support/**/*', __FILE__)].each &method(:require)

class TestCase < Minitest::Test
end
