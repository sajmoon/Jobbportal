module App
  class Categories < Sinatra::Base
    enable :logging

    set :root, File.dirname(__FILE__) + "/.."
    
    before do
      env["warden"].authenticate!
      @current_user = env["warden"].user
    end
    
    before '/new' do
      env["warden"].authenticate!
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
