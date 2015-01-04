SINATRA_ENV = 'test' unless defined?(SINATRA_ENV)

require 'simplecov'
SimpleCov.start do
  add_filter '/spec'
  add_filter '/vendor'
end if ENV["COVERAGE"]

require File.expand_path(File.dirname(__FILE__) + "/../boot")

require 'fabrication'
require 'faker'

require 'minitest/autorun'
require 'minitest/spec'
require 'minitest/pride'
require 'rack/test'

class MiniTest::Spec
    include Rack::Test::Methods
end

#clean the database
Job.auto_migrate!
Company.auto_migrate!
Category.auto_migrate!
