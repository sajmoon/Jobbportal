require 'digest/sha2'
class Company
  include DataMapper::Resource
  include DataMapper::Validate

  attr_accessor :password, :password_confirmation
  
  property :id,         Serial
  property :name,       String,   required: true
  property :created_at, DateTime, required: true, default: DateTime.now
  property :img_url,    String
  property :email,      String,   required: true
  property :role,       String
  property :hashedpassword, String, required: true
  property :salt,       String,   required: true

  has n, :jobs
  has n, :users

  def new_salt
    salt = (0..16).to_a.map{|a| rand(16).to_s(16)}.join
  end

  def encryptpassword(password, salt)
    Digest::SHA512.hexdigest("#{password}:#{salt}")
  end

  def checkpassword(password)
    if Digest::SHA512.hexdigest("#{password}:#{self.salt}") == self.hashedpassword
      true
    else
      false
    end
  end
end
