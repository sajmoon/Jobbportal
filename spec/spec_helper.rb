SINATRA_ENV = 'test' unless defined?(SINATRA_ENV)

require "simplecov"
SimpleCov.start do
  add_filter "/spec"
  add_filter "/vendor"
end if ENV["COVERAGE"]

require_relative File.join('..', 'boot')

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

DatabaseCleaner[:data_mapper].strategy = :transaction
