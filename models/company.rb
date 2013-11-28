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
  property :active,         Boolean,  default: true

  has n, :jobs
  has n, :events

  before :save, :encryptpassword

  validates_uniqueness_of :email, :name

  def new_salt
    salt = (0..16).to_a.map{|a| rand(16).to_s(16)}.join
  end

  def encryptpassword
    unless self.password.nil?
      if self.valid_password?
        self.hashedpassword = Digest::SHA512.hexdigest("#{self.password}:#{self.salt}")
      end
    end
  end

  def checkpassword(password)
    if Digest::SHA512.hexdigest("#{password}:#{self.salt}") == self.hashedpassword
      true
    else
      false
    end
  end

  def valid_password?
    if self.password == self.password_confirmation
      return true
    end
    return false
  end

  def admin?
    role == "admin"
  end

  def company_rep?(id = 0)
    rep = false
    if self.role == Role.rep
      if id.to_i == 0
        rep = true
      elsif self.id == id.to_i
        rep = true
      end
    elsif self.role == Role.admin
      rep = true
    end
    rep
  end

  def self.active
    all(active: true)
  end

  def self.inactive
    all(active: false)
  end

  def logo_url
    if self.img_url.blank?
      return "http://careers.queensu.ca/employers/hireastudent/postajob/jobs.png"
    else
      return self.img_url
    end
  end
end
