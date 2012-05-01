#!/usr/bin/env rackup

require File.dirname(__FILE__) + '/boot.rb'

# use Clogger, format: Clogger::Format::Combined, path: "#{SINATRA_ROOT}/log/#{SINATRA_ENV}.log"
use Rack::MethodOverride
use Rack::Session::Cookie


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

