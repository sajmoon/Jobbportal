SINATRA_ENV = "test" unless defined?(SINATRA_ENV)

require "coveralls"
Coveralls.wear!

require_relative File.join("..", "boot")

DataMapper.finalize.auto_upgrade!

RSpec.configure do |config|
  config.include Rack::Test::Methods

  # def app
  #   Sinatra::Application
  # end

  config.before :each do
    DatabaseCleaner.start
  end
  config.after :each do
    DatabaseCleaner.clean
  end
end

DatabaseCleaner[:data_mapper].strategy = :transaction
