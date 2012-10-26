module App
  class Admin < Sinatra::Base
    enable :logging
    register Sinatra::Flash
    register Sinatra::Authorization

    set :root, File.dirname(__FILE__) + "/.."

    before do 
      authorize_admin
    end

    get "/" do
      @jobs = Job.all(order: :company_id)
      haml :"admin/index"
    end
  end
end
