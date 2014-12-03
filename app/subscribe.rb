module App
  class Subscribers < Generic
    register Sinatra::MailerMethods

    set :root, File.dirname(__FILE__) + "/.."
    
    get "/" do
      authorize! :list, Subscribe
      @subscribers = Subscribe.all
      
      haml :"subscribes/index"
    end

    post "/" do
      authorize! :create, Subscribe
      @subscribe = Subscribe.new(params[:subscribe])
      
      if @subscribe.save
        welcome_mail(@subscribe.email.to_s)
        flash[:success] = "Va bra! Vi har dig nu uppskriven i maillistan."

        redirect "/"
      else
        flash[:warning] = "Det gick inte att spara den mail adressen. Testa igen med en annan?"
        redirect "/"
      end
    end

    get "/preview_mail" do
      authorize! :send, Subscribe
      if params[:what] == "welcome"
        haml :"mail/welcome", {layout: :"mail_layout"}
      elsif params[:what] == "weekly"
        haml :"mail/weekly", {layout: :"mail_layout"}
      else
        flash[:warning] = "Det mailet fanns inte"
        redirect to("/")
      end
    end

    get "/send_mail" do
      authorize! :send, Subscribe
      
      if params[:what] == "welcome"
        welcome_mail(params[:email])
      elsif params[:what] == "weekly"
        WeeklyMailJob.new.perform()
      end
      flash[:success] = "Mail skickas"
      redirect "/"
    end

    get "/:id/delete" do |id|
      authorize! :delete, Subscribe
      sub = Subscribe.get(id)
      email = sub.email

      sub.destroy!

      flash[:success] = "Tog bort #{email}!"
      redirect to("/")


    end
  end
end
