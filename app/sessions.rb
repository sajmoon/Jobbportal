module App
  class Sessions < Sinatra::Base
    set :root, File.dirname(__FILE__)+ "/../"
    enable :logging 
    register Sinatra::Flash
    
    get "/unauthenticated" do
      redirect "/auth/login"
    end

    post "/login" do
      company = Company.first(:email => params[:company][:email])
      if company.nil? || !company.checkpassword(params[:company][:password])
        redirect to("/login")
      else
        
        if company.role == Role.admin
          #flash[:warning] = "Loggat in som admin"
          env["warden"].set_user(company, :scope => :admin )
          puts "user: #{company.name}"
          flash[:warning] = "Loggat in som admin"
        elsif company.role == Role.rep
          #flash[:warning] = "Loggat in som företagsrepresentant"
          env["warden"].set_user(company, :scope => :company)
          flash[:warning] = "Loggat in som representant"
        else
          #flash[:warning] = "scope user"
          env["warden"].set_user(company, :scope => :user)
          flash[:warning] = "Loggat in"
        end
        redirect "/"
        #redirect params["url"]
      end
    end

    get "/failure" do
      "fail"
    end

    get "/logout" do
      env["warden"].logout
      redirect "/"
    end

    get "/login" do
      haml :"sessions/login"
    end
  end
end
