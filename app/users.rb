
module App
  class Users < Sinatra::Base
    set :root, File.dirname(__FILE__)+ "/../"
    set :method_override, true

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
      #env["warden"].authenticate!
      #@current_user = env["warden"].user
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
      @user.ugid = (0..16).to_a.map{|a| rand(16).to_s(16)}.join

      if @user.save
        redirect "/"
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
      @user = User.get(id)
      if @user.update(params["user"])
        redirect to("/")
      else
        haml :'users/edit'
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
      haml :"users/show"
    end
  end
end
