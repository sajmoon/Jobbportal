module App
  class Generic < Sinatra::Base
    configure :production, :development do
      enable :logging
    end

    register Sinatra::Flash
    register Sinatra::Can
    register Sinatra::Authorization

    ability do |company|
      can :list, Job
      can :show, Job
      can :create, Subscribe

      unless company.nil?
        can :view, :header
        if company.admin?
          can :list, :admin
          can :manage, Job
          can :manage, Subscribe
          can :manage, Category
          can :manage, Company
          can :change_company_role, Company
          can :list, :ddagen
        else
          can :create, Job
          can :edit, Job do |j|
            j.company_id == company.id
          end
          can :show, Company do |c|
            c.id == company.id
          end
          can :edit, Company do |c|
            c.id == company.id
          end
        end
      end
    end

    not_found do
      status 404
      haml :oops
    end

    error 403 do
      throw(:warden, message: "Nu har du kommit fel!")
    end
  end
end
