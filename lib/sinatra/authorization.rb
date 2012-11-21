module Sinatra
  module Authorization
    module Helpers
      def authorize_admin
        @current_user = current_user
        if @current_user.nil?
          flash[:warning] = "Du ska inte se detta"
          redirect "/"
        end
        unless @current_user.admin?
          flash[:warning] = "Du ska inte se detta"
          redirect "/"
        end
      end

      def authorize_company_rep(id = 0)
        @current_user = current_user
        unless may_edit(id)
          flash[:warning] = "Du ska inte se detta"
          redirect "/"
        end
      end

      def warden
        env["warden"]
      end

      def may_edit(id = 0)
        is_company_rep?(id)
      end

      def is_company_rep?(id = 0)
        edit = true
        unless current_user.nil?
          unless id == 0
            job = Job.get(id)
            unless current_user.company_rep?(job.company_id) || current_user.admin?
              edit = false
            end
          end
        else
          edit = false;
        end
        edit
      end

      def current_user
        unless env["warden"].nil?
          @current_user = env["warden"].user
        end
      end
    end

    def self.registered(app)
      app.helpers Helpers
    end
  end

  register Authorization
end
