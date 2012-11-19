module App
  class Companies < Sinatra::Base
    enable :logging
    register Sinatra::Flash 
    register Sinatra::Authorization

    set :root,  File.dirname(__FILE__) + "/.."
  
    get "/" do
      authorize_admin
      @companies = Company.all
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
      authorize_company_rep(id)
      @company = Company.get(id)
      haml :"companies/show"
    end

    get '/:id/delete/?' do |id|
      authorize_admin
      @company = Company.get(id)
      if @company.destroy
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

    put "/:id/?" do |id|
      @company = Company.get(id)
      authorize_admin
      
      if @company.update(params[:company])
        flash[:success] = "Updated!"
        redirect to("/")
      else
        haml :"companies/edit"
      end
    end
  end
end
