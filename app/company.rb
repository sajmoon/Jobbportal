module App
  class Companies < Generic
    set :root,  File.dirname(__FILE__) + "/.."
  
    get "/" do
      authorize! :list, Company
      @companies = Company.active
      @inactiveCompanies = Company.inactive
      haml :"companies/index"
    end
  
    # new
    get "/new" do
      authorize! :create, Company
      @company = Company.new
      haml :"companies/new"
    end

    # create
    post "/" do
      authorize! :create, Company
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
      @company = Company.get(id)
      authorize! :show, @company
      haml :"companies/show"
    end

    get "/:id/password/?" do |id|
      @company = Company.get(id)
      authorize! :edit, @company
      haml :"companies/password"
    end

    post "/:id/password/?" do |id|
      @company = Company.get(id)
      authorize! :edit, @company
      
      @company.password               = params[:company][:new_password]
      @company.password_confirmation  = params[:company][:confirm_password]
      
      if @company.valid_password?
        @company.encryptpassword
        @company.save
        flash[:alert] = "Ditt losenord har blivit bytt"
        haml :"companies/show"
      else
        flash[:alert] = "Kunde inte byta losenord"
        haml :"companies/show"
      end
    end

    #delete
    get '/:id/delete/?' do |id|
      @company = Company.get(id)
      authorize! :destroy, @company
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
      @company = Company.get(id)
      authorize! :edit, @company
      haml :"companies/edit"
    end

    get '/:id/activate' do |id|
      authorize! :delete, Company
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
      @company = Company.get(id)
      authorize! :edit, @company
      
      unless can? :change_company_role, @company
        params[:company].reject!{ |k| k == "role"}
      end

      if @company.update(params[:company])
        flash[:success] = "Updated!"
        redirect to("/#{@company.id}")
      else
        haml :"companies/edit"
      end
    end
  end
end
