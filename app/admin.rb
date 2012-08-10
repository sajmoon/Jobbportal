module App
  class Admin < Sinatra::Base
    enable :logging
    register Sinatra::Flash

    set :root, File.dirname(__FILE__) + "/.."

    before do 
      unless Role.is_admin(env["warden"])
        flash[:warning] = "Du ska inte se detta."
        env["warden"].authenticate!
      end
    end

    get "/" do
      @jobs = Job.all(order: :company_id)
      haml :"admin/index"
    end
  end
end
