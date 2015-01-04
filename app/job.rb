module App
  class Jobs < App::Generic
    set :root, File.dirname(__FILE__) + "/.."
    # Use caching
    set :static_cache_control, [:public, :max_age => 300]

    # index
    get "/index" do
      redirect to("/")
    end

    # index
    get "/" do
      authorize! :list, Job
      @jobs = Job.running_now

      haml :"jobs/index"
    end

    # RSS
    get '/rss.xml' do
      @jobs = Job.running_now
      builder do |xml|
        xml.instruct! :xml, :version => '1.0'
        xml.rss :version => "2.0" do
          xml.channel do
            xml.title "Datasektionens Jobbportal"
            xml.description "Htta ett jobb som passar dig."
            xml.link "http://wwww.djobb.se"

            @jobs.each do |job|
              xml.item do
                xml.title job.title
                xml.link "http://www.djobb.se/jobs/#{job.id}"
                xml.description job.short_description
                xml.pubDate Time.parse(job.starttime.to_s).rfc822()
                xml.guid "http://www.djobb.se/jobs/#{job.id}"
              end
            end
          end
        end
      end
    end

    # new
    get "/new" do
      authorize! :create, Job
      @job = Job.new
      @job.weeks = 3
      @categories = Category.all
      @job.company = Role.get_user(env["warden"])

      @job.created_by = Role.get_user(env["warden"]).id
      haml :"jobs/new"
    end

    # create
    post "/" do
      authorize! :create, Job
      @job = Job.new(params[:job])
      @job.company = Company.get(@job.company_id)

      unless params[:categories].nil?
        categories = params[:categories][:id]
        @job.categories = []
       categories.each do |c|
          cat = Category.get(c)
          @job.categories << cat
        end
      end

      if @job.save
        flash[:success] = "Annons skapades"
        redirect to("/")
      else
        @categories = Category.all
        puts "company id: #{@job.company_id}"
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
      unless params[:categories].blank?
        categories = params[:categories][:id]

        @job.categories = []
        categories.each do |c|
          cat = Category.get(c)
          @job.categories << cat
        end
      end
      @job.save

      if @job.update(params[:job])
        flash[:success] = "Annonsen uppdaterades"
        redirect to("/")
      else
        @categories = Category.all
        @companies = Company.all
        haml :'jobs/edit'
      end
    end

    get "/:id/" do |id|
      redirect "/jobs/#{id}", 301
    end

    get "/:id" do |id|
      @job = Job.get(id)
      if @job == nil
        redirect '/', 404
      end
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
      @job.active = !@job.active

      if @job.save
        redirect "/admin"
      else
        redirect "/jobs/#{id}"
      end
    end

    post "/preview" do
      data = params[:text]
      Job.safe_textilize(data)
    end
  end
end
