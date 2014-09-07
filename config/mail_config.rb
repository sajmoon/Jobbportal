require 'mail'

Mail.defaults do
  if Sinatra::Base.production?
    delivery_method :smtp, {
      :address => 'smtp.sendgrid.net',
      :port => 587,
      :domain => 'heroku.com',
      :user_name => ENV['SENDGRID_USERNAME'],
      :password => ENV['SENDGRID_PASSWORD'],
      :authentication => 'plain',
      :enable_starttls_auto => true
    }
  else
    delivery_method LetterOpener::DeliveryMethod, :location => File.expand_path('../tmp/letter_opener', __FILE__)
  end
end