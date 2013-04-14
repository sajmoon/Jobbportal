module App
  class Jobs < App::Generic
    set :root, File.dirname(__FILE__) + "/.."
    
    # index
    get "/" do
      authorize! :list, Job
      @jobs = Job.running_now
      @categories = Category.all
      @selected_categories = Category.all

      if defined?(params[:filter][:id])
        @jobs = Job.all(Job.categories.id => params[:filter][:id].map{ |id| id }).running_now
        @selected_categories = Category.all(:id => params[:filter][:id].map{ |id| id })
      end
      
      haml :"jobs/index"
    end

    get '/rss.xml' do
      @jobs = Job.running_now
      builder do |xml|
        xml.instruct! :xml, :version => '1.0'
        xml.rss :version => "2.0" do
          xml.channel do
            xml.title "Datasektionens Jobbportal"
            xml.description "Htta ett jobb som passar dig."
            xml.link "http://djobb.heroku.com"

            @jobs.each do |job|
              xml.item do
                xml.title job.title
                xml.link "http://djobb.heroku.com/jobs/#{job.id}"
                xml.description job.short_description
                xml.pubDate Time.parse(job.starttime.to_s).rfc822()
                xml.guid "http://djobb.heroku.com/jobs/#{job.id}"
              end
            end
          end
        end
      end
    end
 
    # index
    get "/index" do
      redirect to("/")
    end

    # new
    get "/new" do
      authorize! :create, Job
      @job = Job.new
      @categories = Category.all
      @job.company = Role.get_user(env["warden"])
      if env["warden"].user.admin?
        @companies = Company.all
      end
      
      @job.created_by = Role.get_user(env["warden"]).id
      haml :"jobs/new"
    end

    # create
    post "/" do
      authorize! :create, Job
      @job = Job.new(params[:job])
      @job.created_at = Time.now
      @job.updated_at = Time.now

      @job.company = Company.get(@job.company_id)
      
      @job.endtime = @job.starttime + @job.weeks*7
      
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
      @job = Job.get(id)
      authorize! :edit, @job
      @categories = Category.all
      @companies = []
      if current_user.admin?
        @companies = Company.all
      else
        @companies << Company.get(@job.company_id)
      end
      haml :"jobs/edit"
    end

    #Update!
    put "/:id/?" do |id|
      @job = Job.get(id)
      authorize! :edit, @job
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
      authorize! :show, @job
      @job.viewcount = @job.viewcount + 1
      @job.save!
      
      haml :"jobs/show"
    end

    get "/:id/delete" do |id|
      authorize! :delete, Job
      @job = Job.get(id)
      @job.categories = []
      @job.save!
      @job.destroy!

      redirect "/admin/"
    end

    get "/:id/hide" do |id|
      authorize! :delete, Job
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
