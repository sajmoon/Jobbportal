require_relative "spec_helper.rb"

require "capybara"
require "capybara/dsl"
require "capybara_minitest_spec"

# disable :run
Capybara.app = eval "Rack::Builder.new {(" + File.read(File.dirname(__FILE__) + "/../config.ru") + "\n )}"

RSpec.configure do |config|
    config.include Capybara::DSL
    include Warden::Test::Helpers
    Warden.test_mode!
end

# class MiniTest::Spec
#   include Capybara::DSL
#   include Warden::Test::Helpers
#
#   Capybara.register_driver :selenium do |app|
#     Capybara::Selenium::Driver.new(app, browser: :chrome)
#   end
#
#   before :each do
#     Capybara.default_driver = :selenium
#   end
#
#   after :each do
#     Warden.test_reset!
#     logout
#   end
# end

class Capybara::Session
  def params
    Hash[*URI.parse(current_url).query.split(/\?|=|&/)]
  end
end
