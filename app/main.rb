module App
  class Main < Sinatra::Base
    enable :logging

    set :root, File.dirname(__FILE__) + "/.."

    get "/" do
      redirect "/jobs"
    end
  end
end
