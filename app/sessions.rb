module App
  class Sessions < Sinatra::Base
    set :root, File.dirname(__FILE__)+ "/../"
    enable :logging 

    get "/unauthenticated" do
      redirect "/auth/login"
    end

    post "/login" do
	    user = User.first(:email => params[:user][:email])
      if user.nil? || !user.checkpassword(params[:user][:password])
        redirect to("/login")
      else
        env["warden"].set_user user
        redirect params["url"]
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
