module App
  class Main < Sinatra::Base
    enable :logging

    set :root, File.dirname(__FILE__) + "/.."

    get "/" do
      @jobs = Job.all(limit: 5)
      haml :start_page
    end
  end
end
