#!/usr/bin/env rackup

require File.dirname(__FILE__) + '/boot.rb'

use Rack::MethodOverride
use Rack::Session::Cookie, secret: "secretkey2.0" #TODO Change maybe? =)

#require File.dirname(__FILE__) + '/lib/sinatra/authorization.rb'

use Warden::Manager do |manager|
  manager.failure_app = App::Sessions
  manager.default_strategies :password

  manager.scope_defaults :company,  :strategies => [:password]
  
  manager.serialize_into_session { |user| user.id }
  manager.serialize_from_session { |id| Company.get(id) }
end

Warden::Manager.before_failure do |env,opts|
  env['REQUEST_METHOD'] = 'POST'
end

Warden::Strategies.add(:password) do
  def valid?
    params[:username] || params[:password]
  end

  def authenticate!
    u = Company.authenticate(params[:username], params[:password])
    u.nil? ? fail!("Inloggning misslyckades") : success!(u)
  end
end

Warden::Manager.after_set_user do |user, auth, opts|
  unless user.active?
    auth.logout
    throw(:warden, :message => "Du har ett inaktiverat konto!")
  end
end

def warden_handler
  env['warden']
end

map "/auth" do
  run App::Sessions
end

map "/" do
  run App::Main
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

map "/admin/" do
  run App::Admin
end
