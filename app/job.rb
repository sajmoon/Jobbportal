module App
  class Jobs < Sinatra::Base
    enable :logging

    set :root, File.dirname(__FILE__) + "/.."

    get "/" do
      @jobs = Job.all
      @categories = Category.all
      @selected_categories = []
      haml :"jobs/index"
    end

    post "/index" do
      
      @jobs = Job.all(Job.categories.id => params[:filter][:id].map{ |id| id } )
      @selected_categories = Category.all(:id => params[:filter][:id].map{ |id| id })

      @categories = Category.all
      haml :"jobs/index"
    end

    get "/index" do
      redirect to("/")
    end

    get "/new" do
      @job = Job.new
      @categories = Category.all
      @companies = Company.all
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
      @companies = Company.all
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
      haml :"jobs/show"
    end
      
  end
end
