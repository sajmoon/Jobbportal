module App
  class Categories < Generic
    set :root, File.dirname(__FILE__) + "/.."
    
    before do
      authorize! :manage, Category
    end
    
    get "/" do
      @categories = Category.all
      haml :"categories/index"
    end

    get "/new/?" do
      @category = Category.new
      haml :"categories/new"
    end

    post "/" do
      @category = Category.new(params[:category])
      if @category.save
        flash[:success] = "Ny kategori skapad"
        redirect to("/")
      else
        flash[:alert] = "Misslyckades"
        haml :"categories/new"
      end
    end

    get "/:id/edit/?" do
      @category = Category.get(params[:id])
      haml :"categories/edit"
    end

    put "/:id/?" do |id|
      @category = Category.get(id)
      if @category.update(params[:category])
        flash[:success] = "Updaterade kategorin"    
        redirect "/categories/"
      else
        flash[:alert] = "Misslyckades"
        haml :"categories/edit"
      end
    end

    get "/:id/delete" do |id|
      @category = Category.get(id)

      if @category.destroy
        flash[:notice] = "Kategorin borttagen"
        redirect "/categories/"
      else
        flash[:alert] = "Kunde inte ta bort"
        redirect @category
      end
    end
  end
end
