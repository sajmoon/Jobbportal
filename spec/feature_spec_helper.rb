require_relative "spec_helper.rb"

require 'capybara'
require 'capybara/dsl'
require 'capybara_minitest_spec'

Capybara.app = eval "Rack::Builder.new {(" + File.read(File.dirname(__FILE__) + "/../config.ru") + "\n )}"
#Capybara.default_driver = :webkit

class MiniTest::Spec
  include Capybara::DSL
  include Warden::Test::Helpers

  before do
    logout
  end
  
  after do
    Warden.test_reset!
  end
end

class Capybara::Session
  def params
    Hash[*URI.parse(current_url).query.split(/\?|=|&/)]
  end
end
