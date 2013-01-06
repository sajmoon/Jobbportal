SINATRA_ENV = 'test' unless defined?(SINATRA_ENV)

require File.expand_path(File.dirname(__FILE__) + "/../boot")

require 'bundler'
Bundler.setup
Bundler.require

require 'minitest/autorun'
require 'minitest/spec'
require 'rspec'
require 'rack/test'

def app
  Sinatra::Application
end

RSpec.configure do |conf|
  conf.before(:each) { DataMapper.auto_migrate! }
  conf.include Rack::Test::Methods
end
