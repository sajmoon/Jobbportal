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
  property :salt,           String
  property :created_on,     Date
  property :updated_at,     DateTime
  property :updated_on,     Date
  property :active,         Boolean,  default: true

  has n, :jobs

  before :valid?, :encryptpassword

  validates_uniqueness_of :email, :name

  def ensure_salt
    if should_update_password? || salt.blank?
      self.salt = generate_new_salt
    end
  end

  def generate_new_salt
    self.salt = (0..16).to_a.map { |a| rand(16).to_s(16) }.join
  end

  def encryptpassword
    ensure_salt
    if should_update_password?
      generate_new_salt
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

  def should_update_password?
    !self.password.blank?
  end

  def new_password_should_match
    self.password == self.password_confirmation
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
      return "/img/missing-image-640x360.png"
    else
      return self.img_url
    end
  end
end
