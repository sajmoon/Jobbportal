module App
  class Admin < Generic
    enable :logging
    register Sinatra::Flash
    register Sinatra::Authorization

    set :root, File.dirname(__FILE__) + "/.."

    before do
      authorize! :list, :admin
    end

    get "/" do
      @jobs = Job.all(order: :company_id)
      haml :"admin/index"
    end

    get "/pay/:id/?" do
      @jobs = Job.all(order: :company_id)

      @job = Job.get(params[:id])
      @job.paid = true
      if @job.save
        flash[:notice] = "Markerad som betald"
        haml :"admin/index"
      else
        flash[:alert] = "Kunde inte markeras som betald"
        @errors = @job.errors
        haml :"admin/index"
      end
    end
  end
end
