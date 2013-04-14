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

    get '/dashboard' do
      authorize! :show, :dashboard
      @jobs = Job.running_now
      @events = Event.not_passed
      haml :"dashboard"
    end
  end
end
