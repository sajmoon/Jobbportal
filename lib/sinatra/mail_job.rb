module App
  class WeeklyMailJob < Sinatra::Base
    include SuckerPunch::Job

    set :root, SINATRA_ROOT
    set :public_folder, SINATRA_ROOT + "/public"

    def perform()
      #@subscribes = Subscribe.all
      #emails = @subscribes.map(&:email).join(", ")
      #puts emails
      emails = ["simon.strom@gmail.com", "simstr@kth.se", "eksajm@gmail.com"]
      
      rendered_body = (haml :"mail/weekly", {layout: :"mail_layout"} )

      premailer = Premailer.new(rendered_body, with_html_string: true, :warn_level => Premailer::Warnings::RISKY)
      
      puts "all warnings"
      premailer.warnings.each do |w|
        puts "#{w[:message]} (#{w[:level]}) may not render properly in #{w[:clients]}"
      end

      rendered_body = premailer.to_inline_css

      mail = Mail.deliver do
        to "simon.strom@gmail.com"
        from "dJobb <updates@djobb.se>"
        subject "dJobb - Veckovis uppdatering"
        bcc emails
        content_type 'text/html'
        body rendered_body
      end
    end
  end
end