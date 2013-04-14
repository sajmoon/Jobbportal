module App
  class Sessions < Generic
    set :root, File.dirname(__FILE__) + "/../"
    enable :logging 
    
    register Sinatra::Flash

    get "/unauthenticated" do
      redirect "/"
    end

    post "/unauthenticated" do
      flash[:alert] = env["warden.options"][:message]
      redirect "/"
    end

    get "/login" do
      haml :"sessions/login"
    end

    get "/unauth" do
      haml :"sessions/unauth"
    end
    
    post "/login" do
      company = Company.first(:email => params[:company][:email])
      if company.nil? || !company.checkpassword(params[:company][:password])
        flash[:warning] = "Inloggning misslyckades"
        redirect to("/login")
      else
        env["warden"].set_user(company)
        flash[:success] = "Inloggning lyckades! Hej #{company.name}."
        #redirect params["url"]
      end
      redirect "/"
    end

    get "/failure" do
      flash[:warning] = "Det gick inte som det skulle"
      redirect "/"
    end

    get "/logout" do
      env["warden"].logout
      flash[:success] = "Utloggning lyckades"
      redirect "/"
    end
  end
end
