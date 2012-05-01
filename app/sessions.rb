module App
  class Sessions < Sinatra::Base
    enable :logging 

    get "/unauthenticated" do
      attempted_path = env["warden.options"][:attempted_path]

      redirect "/auth/cas?url=#{attempted_path}"
    end

    %w[get post].each do |method|
      self.send(method, "/cas/callback") do
        ugid = request.env["omniauth.auth"]["uid"]
        user = User.find_or_create_from_ldap(ugid)

        if user.active?
          env["warden"].set_user user
          redirect params["url"]
        else
          throw(:warden)
        end
      end
    end

    get "/failure" do
      "fail"
    end

    delete "/logout" do
      env["warden"].logout
      redirect "/"
    end
  end
end
