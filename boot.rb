# Defines our constants
SINATRA_ENV  = ENV['SINATRA_ENV'] ||= ENV['RACK_ENV'] ||= 'development'  unless defined?(SINATRA_ENV)
SINATRA_ROOT = File.expand_path('..', __FILE__) unless defined?(SINATRA_ROOT)

# load Gem dependencies
require 'bundler/setup'
Bundler.setup
Bundler.require(:default, SINATRA_ENV)

DataMapper::Logger.new($stdout, :debug)
# setup database
require_relative "config/database.rb"

#helpers
require_relative "models/sinatra_before_filter.rb"

require "yaml"
require "sinatra/flash"
require "date"
require "haml"

require "json"

# Background process
require "sucker_punch"

# add lib to load path
$LOAD_PATH.unshift "lib"

require "sinatra/authorization"
require "sinatra/mailer_methods"

require "sinatra/can"

if SINATRA_ENV == "production"
  require "newrelic_rpm"
end

# require sub-apps
require_relative "app/generic.rb"
Dir.glob("app/*.rb").each do |app|
  require_relative app
end

# require models
Dir.glob("models/*.rb").each do |model|
    require_relative model
end

require_relative "lib/sinatra/mail_job"

## Helpers
def cycle
  %w{even odd}[@_cycle = ((@_cycle || -1) + 1) % 2]
end

CYCLE = %w{even odd}
def cycle_fully_sick
  CYCLE[@_cycle = ((@_cycle || -1) + 1) % 2]
end

DataMapper.finalize
