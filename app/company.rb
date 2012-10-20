module App
  class Companies < Sinatra::Base
    enable :logging
    register Sinatra::Flash 
    
    set :root,  File.dirname(__FILE__) + "/.."

    def check_auth
      unless Role.is_admin(env["warden"])
        flash[:warning] = "You are not authorized to do that."
        redirect "/"
      end
      @current_user = Role.get_user(env["warden"])
    end

    def check_auth_self(id)
      unless Role.get_user(env["warden"]).id.to_s == id
        flash[:warning] = "You are not authorized to see this profile"
        redirect "/"
      end
      @current_user = Role.get_user(env["warden"])
    end

    get "/" do
      check_auth
      @companies = Company.all
      haml :"companies/index"
    end
  
    # new
    get "/new" do
      check_auth
      @company = Company.new
      haml :"companies/new"
    end

    # create
    post "/" do
      check_auth
      @company = Company.new(params[:company])
      puts "post!"
      
      unless params[:company][:password].nil?
        @company.salt = @company.new_salt
      end

      if @company.save
        redirect to("/")
      else
        haml :"companies/new"
      end
    end

    # show
    get "/:id/?" do |id|
      check_auth_self(id)
      @company = Company.get(id)
      haml :"companies/show"
    end
  end
end
