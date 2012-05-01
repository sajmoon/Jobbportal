#!/usr/bin/env rackup

require File.dirname(__FILE__) + '/boot.rb'

# use Clogger, format: Clogger::Format::Combined, path: "#{SINATRA_ROOT}/log/#{SINATRA_ENV}.log"
use Rack::MethodOverride
use Rack::Session::Cookie

use OmniAuth::Builder do
  provider :cas, :host => "login.kth.se", :ssl => true
end

Warden::Manager.serialize_into_session {|user| user.id }
Warden::Manager.serialize_from_session {|id| User.get(id) }

use Warden::Manager do |manager|
  manager.failure_app = App::Sessions
end

map "/auth" do
  run App::Sessions
end

map "/" do
  run App::Main
end

map "/users" do
  run App::Users
end

map "/jobs/" do
  run App::Jobs
end

map "/categories/" do
  run App::Categories
end

map "/companies/" do
  run App::Companies
end

