#!/usr/bin/env rackup

require File.dirname(__FILE__) + '/boot.rb'

use Rack::MethodOverride
use Rack::Session::Cookie, secret: "secretkey2.0" #TODO Change maybe? =)

Warden::Manager.serialize_into_session {|user| user.id }
Warden::Manager.serialize_from_session {|id| User.get(id) }

use Warden::Manager do |manager|
  manager.default_strategies :password
  manager.failure_app = App::Sessions
end

Warden::Strategies.add(:password) do

  def valid?
    params[:username] || params[:password]
  end

  def authenticate!
    u = User.authenticate(params[:username], params[:password])
    u.nil? ? fail!("Could not log in") : success!(u)
  end
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

