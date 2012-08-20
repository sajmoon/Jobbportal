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
        flash[:success] = "Ny kategori skapad"
        redirect to("/")
      else
        haml :"categories/new"
      end
    end

    get "/:id/edit" do
      @category = Category.get(params[:id])
      haml :"categories/edit"
    end

    put "/:id" do |id|
      @category = Category.get(id)
      if @category.update(params[:category])
        flash[:success] = "Updaterade kategorin"    
        redirect "/categories/"
      else
        haml :"categories/edit"
      end
    end
  end
end
