module App
  class Main < Sinatra::Base
    enable :logging

    set :root, File.dirname(__FILE__) + "/.."

    get "/" do
      @jobs = Job.all(limit: 5, active: true)
      @categories = Category.all
      @selected_categories = []
      haml :start_page
    end
  end
end
