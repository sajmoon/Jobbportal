# Defines our constants
SINATRA_ENV  = ENV['SINATRA_ENV'] ||= ENV['RACK_ENV'] ||= 'development'  unless defined?(SINATRA_ENV)
SINATRA_ROOT = File.expand_path('..', __FILE__) unless defined?(SINATRA_ROOT)

# load Gem dependencies
require 'bundler/setup'
Bundler.setup
Bundler.require(:default, SINATRA_ENV)

# setup database
require_relative "config/database.rb"

# setup ldap
require 'ldap_lookup'
require 'yaml'
LDAPLookup::Importable.settings = YAML.load(File.read('config/ldap.yml'))[SINATRA_ENV]

require 'yaml'

# add lib to load path
$LOAD_PATH.unshift 'lib'

# require sub-apps
Dir.glob("app/*.rb").each do |app|
  require_relative app
end

# require models
Dir.glob("models/*.rb").each do |model|
  require_relative model
end

DataMapper::Logger.new($stdout, :debug)

DataMapper.finalize

