module App
  class Categories < Sinatra::Base
    enable :logging
    register Sinatra::Flash

    set :root, File.dirname(__FILE__) + "/.."
    
    before do
      unless Role.is_admin(env["warden"])
        flash[:warning] = "Du ska inte se detta."
        redirect "/"
      end
    end
    
    get "/" do
      @categories = Category.all
      haml :"categories/index"
    end

    get "/new" do
      @category = Category.new
      haml :"categories/new"
    end

    post "/" do
      @category = Category.new(params[:category])
      if @category.save
        redirect to("/")
      else
        haml :"categories/new"
      end
    end
  end
end
