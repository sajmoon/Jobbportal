module App
  class Jobs < Sinatra::Base
    enable :logging
    register Sinatra::Flash
    register Sinatra::Reloader

    set :root, File.dirname(__FILE__) + "/.."

    before_filter [[:new, "/new"], [:del, "/delete"], [:edit, "/:id/edit"]] do
      unless Role.is_company_rep(env["warden"], params[:id])
        flash[:warning] = "Du ska inte se detta."
        env["warden"].authenticate!
      end
    end

    get "/" do
      @jobs = Job.all(order: [ :created_at.desc]).running_now
      @categories = Category.all
      @selected_categories = Category.all
      haml :"jobs/index"
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

    get "/index" do
      redirect to("/")
    end

    get "/new" do
      @job = Job.new
      @categories = Category.all
      @job.company = Role.get_user(env["warden"])
      if Role.is_admin(env["warden"])
        @companies = Company.all
      end
      @job.created_by = Role.get_user(env["warden"]).id
      haml :"jobs/new"
    end

    post "/" do
      @job = Job.new(params[:job])
      @job.created_at = Time.now
      @job.updated_at = Time.now

      categories = params[:categories][:id]
  
      @job.company = Company.get(@job.company_id)
      
      @job.categories = []
      categories.each do |c|
        cat = Category.get(c)
        @job.categories << cat
      end

      if @job.save
	      redirect to("/")
      else
        @categories = Category.all
        if Role.is_admin(env["warden"])
          @companies = Company.all
        else 
          @companies = []
        end
        haml :"jobs/new"
      end
    end

    get "/:id/edit" do |id|
      @job = Job.get(id)
      @categories = Category.all
      if Role.is_admin(env["warden"])
        @companies = Company.all
      else 
        @companies = []
      end
      haml :"jobs/edit"
    end


    put "/:id" do |id|
      @job = Job.get(id)
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

    get "/:id/" do |id|
      @job = Job.get(id)
      @job.viewcount = @job.viewcount + 1
      @job.save!
      
      haml :"jobs/show"
    end

    get "/:id/delete" do |id|
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
