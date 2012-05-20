module App
  class Jobs < Sinatra::Base
    enable :logging
    register Sinatra::Flash

    set :root, File.dirname(__FILE__) + "/.."

    before_filter [[:new, "/new"], [:del, "/delete"], [:edit, "/:id/edit"]] do
      unless Role.is_company_rep(env["warden"], params[:id])
        flash[:warning] = "Du ska inte se detta."
        authenticate!
      end
    end

    get "/" do
      @jobs = Job.all
      @categories = Category.all
      @selected_categories = []
      haml :"jobs/index"
    end
    
    post "/filter" do
      @jobs
      @selected_categories = []
      puts params[:filter][:id].map{ |id| id}
      if defined?(params[:filter][:id])
        @jobs = Job.all(Job.categories.id => params[:filter][:id].map{ |id| id } )

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
      if Role.is_admin(env["warden"])
        @companies = Company.all
      else 
        @companies = []
        @companies << Company.get(@current_user.company_id)
      end
      @job.created_by = Role.get_user(env["warden"]).id
      haml :"jobs/new"
    end

    post "/" do
      @job = Job.new(params[:job])
      @job.created_at = Time.now
      @job.updated_at = Time.now

      categories = params[:categories][:id]
  
      @job.categories = []
      categories.each do |c|
        cat = Category.get(c)
        @job.categories << cat
      end

      if @job.save
	      redirect to("/")
      else
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
        @companies << Company.get(Role.get_user(env["warden"]).company_id)
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
      puts "delete!"
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
