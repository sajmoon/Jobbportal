module App
  class Sessions < Generic
    set :root, File.dirname(__FILE__) + "/../"

    set :static_cache_control, [:public, :max_age => 300]

    register Sinatra::Flash

    get "/unauthenticated" do
      redirect "/"
    end

    post "/unauthenticated" do
      flash[:alert] = "Du kunde inte logga in"
      redirect "/"
    end

    get "/login" do
      haml :"sessions/login"
    end

    get "/unauth" do
      haml :"sessions/unauth"
    end

    post "/login" do
      p "post login"
      env["warden"].authenticate!

      flash[:success] = "Du har loggats in"

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
