module App
  class DDagen < Sinatra::Base
    enable :logging
    register Sinatra::Authorization
    register Sinatra::Flash

    set :root, File.dirname(__FILE__) + "/.."

    get "/" do
      haml :"d-dagen/index", layout: :"d-dagen-layout"
    end
  end
end
