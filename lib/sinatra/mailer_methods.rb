require 'haml'

module Sinatra
  module MailerMethods
    module Helpers
      def welcome_mail(email)

        renderedBody = (haml :"mail/welcome", {layout: :"mail_layout"} )
        mail = Mail.deliver do
          to email
          from "updates@djobb.se"
          subject "dJobb - Valkommen till oss"
          
          content_type 'text/html'
          body renderedBody
        end
      end

    end

    def self.registered(app)
      app.helpers Helpers
    end
  end

  register MailerMethods
end
