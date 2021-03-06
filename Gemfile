source "https://rubygems.org"

ruby ENV['CUSTOM_RUBY_VERSION'] || '2.1.5'

gem 'rake'

gem 'sinatra', require: "sinatra/base"
gem 'sinatra-flash'

gem 'haml'

gem 'builder'
gem 'json'

# Unicorn
gem 'unicorn'

# Background worker
gem 'sucker_punch'

#datamapper
gem 'dm-validations'
gem 'dm-constraints'
gem 'dm-migrations'
gem 'dm-aggregates'
gem 'dm-types'
gem 'dm-core'
gem 'dm-timestamps'
gem 'dm-serializer'
gem 'dm-transactions'

#user auth
gem 'warden'
gem 'sinatra-can'
gem 'sinatra-contrib'

gem 'redcarpet'

gem 'mail'
gem 'premailer'
gem 'hpricot'

group :production do
  gem 'rack-google-analytics'
  gem 'pg'
  gem 'dm-postgres-adapter'
  gem 'newrelic_rpm'
end

group :development, :test do
  gem 'letter_opener'
  gem 'selenium-webdriver'
  gem 'rspec'
end

group :development do
  gem 'sqlite3'
end

group :test do
  gem 'rack-test', require: "rack/test"

  gem 'minitest'

  gem 'fabrication'
  gem 'faker'
  gem 'capybara'

  gem 'capybara_minitest_spec'

  gem 'dm-sqlite-adapter'
  gem 'coveralls', require: false
  gem 'database_cleaner'
end
