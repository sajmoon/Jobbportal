module App
  class Companies < Sinatra::Base
    enable :logging

    set :root,  File.dirname(__FILE__) + "/.."

    get "/" do
      @companies = Company.all
      haml :"companies/index"
    end

    get "/new" do
      @company = Company.new
      haml :"companies/new"
    end

    post "/" do
      @company = Company.new(params[:company])
      if @company.save
        redirect to("/")
      else
        haml :"companies/new"
      end
    end

    get "/:id/" do |id|
      @company = Company.get(id)
      haml :"companies/show"
    end
  end
end
