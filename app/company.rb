module App
  class Companies < Sinatra::Base
    enable :logging
    register Sinatra::Flash 
    register Sinatra::Authorization

    set :root,  File.dirname(__FILE__) + "/.."
  
    get "/" do
      authorize_admin
      @companies = Company.active
      @inactiveCompanies = Company.inactive
      haml :"companies/index"
    end
  
    # new
    get "/new" do
      authorize_admin
      @company = Company.new
      haml :"companies/new"
    end

    # create
    post "/" do
      authorize_admin
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
      @current_user = current_user
      unless @current_user.nil? 
        @company = @current_user
        haml :"companies/show"
      else
        flash[:alert] = "Nope"
        haml :"/"
      end
    end

    get "/:id/password/?" do |id|
      authorize_admin
      @company = Company.get(id)
      unless @company.nil?
        haml :"companies/password"
      else
        flash[:alert] = "Logga in forst"
        redirect to("/")
      end
    end

    post "/:id/password/?" do |id|
      authorize_admin
      @company = Company.get(id)
      
      @company.password               = params[:company][:new_password]
      @company.password_confirmation  = params[:company][:confirm_password]
      
      unless @company.nil?
        if @company.valid_password?
          @company.encryptpassword
          @company.save
          flash[:alert] = "Ditt losenord har blivit bytt"
          haml :"companies/show"
        else
          flash[:alert] = "Kunde inte byta losenord"
          haml :"companies/show"
        end
      else
        puts "not signed in"
        flash[:alert] = "Du borde logga in.."
        haml :"companies/#{id}/password"
      end
    end

    #delete
    get '/:id/delete/?' do |id|
      authorize_admin
      @company = Company.get(id)
      @company.active = false
      if @company.save
        flash[:success] = "Tog bort foretag"
        redirect "/companies/"
      else
        flash[:success] = "Kunde inte ta bort foretaget"
        redirect "/companies/#{id}/"
      end
    end

    get '/:id/edit/?' do |id|
      authorize_admin
      @company = Company.get(id)
      haml :"companies/edit"
    end

    get '/:id/activate' do |id|
      authorize_admin
      @company = Company.get(id)
      @company.active = true
      if @company.save
        flash[:success] = "Aktiverat"
        redirect "/companies/#{@company.id}/"
      else
        flash[:alert] = "Det gick inte"
        redirect "/companies/"
      end
    end

    # update
    put "/:id/?" do |id|
      authorize_admin
      @company = Company.get(id)
      
      if @company.update(params[:company])
        flash[:success] = "Updated!"
        redirect to("/")
      else
        haml :"companies/edit"
      end
    end
  end
end
