module App
  class Users < Sinatra::Base
    set :root, File.dirname(__FILE__)+ "/../"
    set :method_override, true
    register Sinatra::Flash
    register Sinatra::Reloader

    helpers do
      def user_status(user)
        if user.active?
          haml "%span.label.label-success Aktiv"
        else
          haml "%span.label Inaktiv"
        end
      end
    end

    before do
      unless Role.is_admin(env["warden"]) || Role.is_company_rep(env["warden"])
        flash[:warning] = "You are not authorized to do that"
        env["warden"].authenticate!
      end
      @current_user = Role.get_user(env["warden"])      
    end

    get "/" do
      @users = User.all
      haml :'users/index'
    end

    get "/new" do
      @user = User.new
      haml :'users/new'
    end

    post "/" do
      @user = User.new(params[:user])

      @user.salt = @user.new_salt
      @user.hashedpassword = @user.encryptpassword(params[:user][:password], @user.salt)
      @created_at = Time.now

      if @user.save
        redirect "/users/"
      else
        @errors = @user.errors
        haml :'users/new'
      end
    end

    get "/:id/edit" do |id|
      @user = User.get(id)
      haml :'users/edit'
    end

    put "/:id" do |id|
      if @user.id == @current_user.id || Role.is_admin(env["warden"])
        @user = User.get(id)
        if @user.update(params["user"])
          redirect to("/")
        else
          haml :'users/edit'
        end
      else
        redirect "/"
      end
    end

    delete "/:id" do |id|
      user = User.get(id)
      if user != current_user && user.destroy
        flash[:notice] = 'User was successfully destroyed.'
      else
        flash[:error] = 'Unable to destroy User!'
      end
      redirect url(:users, :index)
    end

    get "/:id" do |id|
      @user = User.get(id)
      if @user.id == @current_user.id
        haml :"users/show"
      else
        redirect "/"
      end
    end
  end
end
