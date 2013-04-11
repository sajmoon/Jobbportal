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
        flash[:alert] = "Det gick inte att spara den mail adressen. Testa igen med en annan?"
        redirect "/"
      end
    end

    get "/preview_mail" do
      if params[:what] == "welcome"
        haml :"mail/welcome", {layout: :"mail_layout"}
      else
        flash[:alert] = "Det mailet fanns inte"
        redirect to("/")
      end
    end

    get "/sendIntroMail" do
      authorize! :send, Subscribe
      @subscribes = Subscribe.all

      s = @subscribes.first 

      mail = Mail.deliver do
        to s.email.to_s
        from "noreply@djobb.se"
        subject "dJobb - Valkommen"
        text_part do
            body "Hejsan! Detta aer det veckovisa nyhetsbrevet"
        end
      end
    end
  end
end
