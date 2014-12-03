module App
  class Generic < Sinatra::Base
    enable :logging
    register Sinatra::Flash
    register Sinatra::Can
    register Sinatra::Authorization

    ability do |user|
      #unsigned in
      can :list, Job
      can :show, Job
      can :create, Subscribe
      
      unless user.nil?
        can :view, :header
        if user.admin?
          #admin
          can :list, :admin
          can :manage, Job
          can :manage, Subscribe
          can :manage, Category
          can :manage, Company
          can :change_company_role, Company
          can :list, :ddagen
        else
          # Not admin
          can :create, Job
          can :edit, Job do |j|
            j.company_id == user.id
          end
          can :show, Company do |c|
            c.id == user.id
          end
          can :edit, Company do |c|
            c.id == user.id
          end
        end
      end
    end

    user do
      env["warden"].user
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
