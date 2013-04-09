module App
  class Subscribers < Generic
    
    set :root, File.dirname(__FILE__) + "/.."
    
    get "/" do
      authorize! :list, Subscribe
      @subscribers = Subscribe.all
      
      haml :"subscribes/index"
    end

    post "/" do
      authorize! :create, Subscribe
      puts params[:subscribe]
      @subscribe = Subscribe.new(params[:subscribe])
      
      puts @subscribe.email
      if @subscribe.save
        flash[:success] = "Vi mailar dig."
        redirect "/"
      else
        flash[:alert] = "Det gick typ inte."
        redirect "/"
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
