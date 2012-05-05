SINATRA_ENV = 'test' unless defined?(SINATRA_ENV)
require File.expand_path(File.dirname(__FILE__) + "/../boot")

require 'bundler'
Bundler.setup
Bundler.require

require 'minitest/spec'
require 'rack/test'

class MiniTest::Spec
  include Rack::Test::Methods
end
