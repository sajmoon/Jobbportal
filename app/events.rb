module App
  class Events < Generic
    set :root, File.dirname(__FILE__) + "/.."

    get '/' do
      authorize! :list, Event
      @events = Event.not_passed
      @passed_events = Event.passed
      haml :"events/index"
    end

    get '/new' do
      authorize! :create, Event
      @event = Event.new(starttime: Time.now)
      @companies = Company.all
      @event.company = Role.get_user(env["warden"])
      haml :"events/new"
    end
    
    get "/:id/?" do |id|
      @event = Event.get(id)
      authorize! :show, @event
      haml :"events/show"
    end

    post "/" do
      authorize! :create, Event
      puts params
      @event = Event.new(params[:event])

      if @event.save
        redirect to("/")
      else
        haml :"events/new"
      end
    end
  end
end
