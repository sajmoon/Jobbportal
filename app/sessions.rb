module App
  class Sessions < Sinatra::Base
    set :root, File.dirname(__FILE__)+ "/../"
    enable :logging 
    register Sinatra::Flash

    get "/unauthenticated" do
      redirect "/auth/login"
    end

    post "/login" do
	    user = User.first(:email => params[:user][:email])
      if user.nil? || !user.checkpassword(params[:user][:password])
        redirect to("/login")
      else
        
        if user.role == Role.admin
          #flash[:warning] = "Loggat in som admin"
          env["warden"].set_user(user, :scope => :admin )
          flash[:warning] = "Loggat in som admin"
        elsif user.role == Role.rep
          #flash[:warning] = "Loggat in som företagsrepresentant"
          env["warden"].set_user(user, :scope => :company)
          flash[:warning] = "Loggat in som representant"
        else
          #flash[:warning] = "scope user"
          env["warden"].set_user(user, :scope => :user)
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
