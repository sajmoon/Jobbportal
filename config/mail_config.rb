require 'mail'

Mail.defaults do
  if Sinatra::Base.production?
    delivery_method :smtp, {
      :address => 'smtp.mandrillapp.com',
      :port => 587,
      :domain => 'heroku.com',
      :user_name => ENV['MANDRILL_USERNAME'],
      :password => ENV['MANDRILL_APIKEY'],
      :authentication => 'plain',
      :enable_starttls_auto => true
    }
  else
    delivery_method LetterOpener::DeliveryMethod, :location => File.expand_path('../tmp/letter_opener', __FILE__)
  end
end