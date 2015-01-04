require_relative "spec_helper.rb"

Capybara.app = eval "Rack::Builder.new {(" + File.read(File.dirname(__FILE__) + "/../config.ru") + "\n )}"

RSpec.configure do |config|
    config.include Capybara::DSL
    include Warden::Test::Helpers
    Warden.test_mode!
end
