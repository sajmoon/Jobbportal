source "https://rubygems.org"

gem 'rake'

gem 'sinatra', require: "sinatra/base"
gem 'sinatra-flash'

gem 'eventmachine', '1.0.0.rc.4'
gem 'thin'

gem 'haml'

gem 'builder'

#datamapper
gem 'dm-validations'
gem 'dm-constraints'
gem 'dm-migrations'
gem 'dm-aggregates'
gem 'dm-types'
gem 'dm-core'
gem 'dm-timestamps'

#user auth
gem 'warden'
gem 'sinatra-can'
gem 'sinatra-contrib'

gem 'RedCloth'
  
gem 'mail'

group :production do
  gem 'rack-google-analytics'
  gem 'pg', '0.10.0'
  gem 'dm-postgres-adapter'
  gem 'newrelic_rpm'
end

group :development, :test do
  gem 'letter_opener'
end

group :development do
  gem 'sqlite3'
  gem 'shotgun'
end

group :test do
  gem 'rack-test', require: "rack/test"

  gem 'minitest'
 
  gem 'fabrication'
  gem 'faker'
  gem 'capybara'

  gem 'capybara_minitest_spec'

  gem 'dm-sqlite-adapter'
end
