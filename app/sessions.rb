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
        flash[:warning] = "Inloggning misslyckades"
        redirect to("/login")
      else
        
        if company.role == Role.admin
          env["warden"].set_user(company, :scope => :admin )
          puts "user: #{company.name}"
          flash[:success] = "Loggat in som admin"
        elsif company.role == Role.rep
          env["warden"].set_user(company, :scope => :company)
          flash[:success] = "Loggat in som representant"
        else
          env["warden"].set_user(company, :scope => :user)
          flash[:success] = "Loggat in"
        end
        redirect "/"
        #redirect params["url"]
      end
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

    get "/login" do
      haml :"sessions/login"
    end
  end
end
