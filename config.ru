#!/usr/bin/env rackup

require File.dirname(__FILE__) + '/boot.rb'

use Rack::MethodOverride
use Rack::Session::Cookie, secret: ENV["SESSION_SECRET"]
use Rack::Deflater

if Sinatra::Base.production?
  use Rack::GoogleAnalytics, :tracker => ENV['G_ANALYTIC']
end

require File.dirname(__FILE__) + '/config/mail_config.rb'

use Warden::Manager do |manager|
  manager.failure_app = App::Sessions
  manager.default_strategies :password

  manager.scope_defaults :company,  :strategies => [:password]

  manager.serialize_into_session { |company| company.id }
  manager.serialize_from_session { |id| Company.get(id) }
end

Warden::Manager.before_failure do |env,opts|
  env['REQUEST_METHOD'] = 'POST'
end

Warden::Strategies.add(:password) do
  def valid?
    params["company"]["username"] || params["company"]["password"]
  end

  def authenticate!
    company = Company.first(email: params["company"]["email"])

    if company.nil?
      fail!("Inloggning misslyckades")
    elsif company.checkpassword(params["company"]["password"])
      success!(company)
    else
      fail!("Inloggning misslyckades")
    end
  end
end

Warden::Manager.after_set_user do |user, auth, opts|
  unless user.active?
    auth.logout
    throw(:warden, message: "Du har ett inaktiverat konto!")
  end
end

def warden_handler
  env['warden']
end

map "/auth" do
  run App::Sessions
end

map "/" do
  run App::Jobs
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

map "/subscribes/" do
  run App::Subscribers
end
