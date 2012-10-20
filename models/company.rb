require 'digest/sha2'
class Company
  include DataMapper::Resource
  include DataMapper::Validate

  attr_accessor :password, :password_confirmation
  
  property :id,             Serial
  property :name,           String,   required: true
  property :img_url,        String
  property :email,          String,   required: true
  property :role,           String
  property :hashedpassword, String
  property :salt,           String,   required: true
  property :created_on,     Date
  property :updated_at,     DateTime
  property :updated_on,     Date

  has n, :jobs
  has n, :users

  before :save, :encryptpassword

  validates_uniqueness_of :email, :name

  def new_salt
    salt = (0..16).to_a.map{|a| rand(16).to_s(16)}.join
  end

  def encryptpassword
    unless self.password.nil?
      self.hashedpassword = Digest::SHA512.hexdigest("#{self.password}:#{self.salt}")
    end
  end

  def checkpassword(password)
    if Digest::SHA512.hexdigest("#{password}:#{self.salt}") == self.hashedpassword
      true
    else
      false
    end
  end
end
