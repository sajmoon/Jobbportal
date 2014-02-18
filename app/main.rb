module App
  class Main < Generic
    enable :logging

    set :root, File.dirname(__FILE__) + "/.."

    get "/" do
      if can? :show, :dashboard
        redirect to("/dashboard")
      else
        redirect "/jobs"
      end
    end
  end
end
