SINATRA_ENV = 'test' unless defined?(SINATRA_ENV)
ENV['RACK_ENV'] = 'test'

require "simplecov"
SimpleCov.start do
  add_filter "/spec"
  add_filter "/vendor"
end if ENV["COVERAGE"]

require_relative File.join('..', 'boot')

# require 'dm-transactions'
# require 'database_cleaner'

# require "fabrication"
# require "faker"

require "minitest/autorun"
require "minitest/spec"
require "rack/test"

DataMapper.finalize.auto_upgrade!

RSpec.configure do |config|
  config.include Rack::Test::Methods

  config.before :each do
    DatabaseCleaner.start
  end
  config.after :each do
    DatabaseCleaner.clean
  end
end

def app
  described_class
end

class MiniTest::Spec
  include Rack::Test::Methods
  before do
    DatabaseCleaner.clean
  end

  before :each do
    DatabaseCleaner.start
  end

  after :each do
    DatabaseCleaner.clean
  end
end

DatabaseCleaner[:data_mapper].strategy = :transaction

#clean the database
# Job.auto_migrate!
# Company.auto_migrate!
# Category.auto_migrate!
