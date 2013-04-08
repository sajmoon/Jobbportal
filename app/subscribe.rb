module App
  class Subscribers < Sinatra::Base
    register Sinatra::Flash 
    register Sinatra::Authorization
    
    set :root, File.dirname(__FILE__) + "/.."
    
    get "/" do
      authorize_admin
      @subscribers = Subscribe.all
      
      haml :"subscribes/index"
    end

    post "/" do
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
  end
end
