#!/usr/bin/env rackup

require File.dirname(__FILE__) + '/boot.rb'

use Rack::MethodOverride
use Rack::Session::Cookie, secret: "secretkey2.0" #TODO Change maybe? =)

Warden::Manager.serialize_into_session {|user| user.id }
Warden::Manager.serialize_from_session {|id| User.get(id) }

use Warden::Manager do |manager|
  manager.failure_app = App::Sessions

  manager.default_scope = :user

  manager.scope_defaults :user,     :strategies => [:password]
  manager.scope_defaults :company,  :strategies => [:password]
  manager.scope_defaults :admin,    :strategies => [:password]

end

Warden::Strategies.add(:password) do

  def valid?
    params[:username] || params[:password]
  end

  def authenticate!
    u = User.authenticate(params[:username], params[:password])
    u.nil? ? fail!("Du kan inte logga in") : success!(u)
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

