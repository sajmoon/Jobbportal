require 'haml'

module Sinatra
  module MailerMethods
    module Helpers
      def welcome_mail(email)

        renderedBody = (haml :"mail/welcome", {layout: :"mail_layout"} )
        mail = Mail.deliver do
          to email
          from "dJobb <updates@djobb.se>"
          subject "dJobb - Valkommen till oss"
          
          content_type 'text/html'
          body renderedBody
        end
      end

      def weekly_mail(email)
        renderedBody = (haml :"mail/weekly", {layout: :"mail_layout"} )
        mail = Mail.deliver do
          to email
          from "dJobb <updates@djobb.se>"
          subject "dJobb - Veckovis uppdatering"
          
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
