module App
  class Jobs < Sinatra::Base
    register Sinatra::Flash
    register Sinatra::Authorization

    set :root, File.dirname(__FILE__) + "/.."
    
    # index
    get "/" do
      @jobs = Job.all(order: [ :created_at.desc]).running_now
      @categories = Category.all
      @selected_categories = Category.all
      haml :"jobs/index"
    end
    
    get "/filter" do
      "nu gjorde du fel"
    end

    post "/filter" do
      @jobs
      @selected_categories = []

      if defined?(params[:filter][:id])
        @jobs = Job.all(Job.categories.id => params[:filter][:id].map{ |id| id } , order: [ :created_at.desc ] ).running_now
        @selected_categories = Category.all(:id => params[:filter][:id].map{ |id| id })
      else
        @jobs = Job.all
      end
      
      @categories = Category.all

      haml :"jobs/index"
    end

    # index
    get "/index" do
      redirect to("/")
    end

    # new
    get "/new" do
      authorize_company_rep
      @job = Job.new
      @categories = Category.all
      @job.company = Role.get_user(env["warden"])
      puts "new"
      if env["warden"].user.admin?
        @companies = Company.all
      end
      
      @job.created_by = Role.get_user(env["warden"]).id
      haml :"jobs/new"
    end

    # create
    post "/" do
      @job = Job.new(params[:job])
      authorize_company_rep(@job.company_id)
      @job.created_at = Time.now
      @job.updated_at = Time.now

      @job.company = Company.get(@job.company_id)
      
      puts "company: #{@job.company}"
      unless params[:categories].nil?
        categories = params[:categories][:id]
        @job.categories = []
        categories.each do |c|
          cat = Category.get(c)
          @job.categories << cat
        end
      end
      
      @companies = []
      if @job.save
	      redirect to("/")
      else
        @categories = Category.all
        puts "company id: #{@job.company_id}"
        if Role.is_admin(env["warden"])
          @companies = Company.all
        else 
          @companies << Company.get(@job.company_id)
        end
        haml :"jobs/new"
      end
    end

    # edit
    get "/:id/edit/?" do |id|
      authorize_company_rep(id)
			@job = Job.get(id)
      @categories = Category.all
      @companies = []
      if current_user.admin?
				@companies = Company.all
			elsif may_edit(id)
        @companies << Company.get(@job.company_id)
			else
				puts "else"
				redirect "/" 
      end
      haml :"jobs/edit"
    end

    #Update!
    put "/:id/?" do |id|
      @job = Job.get(id)
      authorize_company_rep(id)
      categories = params[:categories][:id]
  
      @job.categories = []
      categories.each do |c|
        cat = Category.get(c)
        @job.categories << cat
      end
      @job.save
      
      if @job.update(params[:job])
        redirect to("/")
      else
        @categories = Category.all
        @companies = Company.all
        haml :'jobs/edit'
      end
    end

    get "/:id/?" do |id|
      @job = Job.get(id)
      @job.viewcount = @job.viewcount + 1
      @job.save!
      
      haml :"jobs/show"
    end

    get "/:id/delete" do |id|
      authorize_admin
      @job = Job.get(id)
      @job.active = false

      if @job.save
        redirect "/"
      else
        redirect "/jobs/#{id}"
      end
    end
  end
end
