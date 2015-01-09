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

  validates_with_method :presence_of_password
  before :valid?, :encryptpassword

  validates_uniqueness_of :email, :name

  def presence_of_password
    if should_update_password? && !new_passwords_match?
      [ false, "Lösenord matchar inte" ]
    else
      true
    end
  end

  def ensure_salt
    if should_update_password? || salt.blank?
      self.salt = generate_new_salt
    end
  end

  def generate_new_salt
    (0..16).to_a.map { |a| rand(16).to_s(16) }.join
  end

  def encryptpassword
    ensure_salt
    if should_update_password?
      if new_passwords_match?
        self.salt = generate_new_salt
        self.hashedpassword = digest_password(password, self.salt)
      end
    end
  end

  def checkpassword(pwd)
    digest_password(pwd, salt) == hashedpassword
  end

  def digest_password(pwd, in_salt)
    Digest::SHA512.hexdigest("#{pwd}:#{in_salt}")
  end

  def should_update_password?
    !password.blank?
  end

  def new_passwords_match?
    password == password_confirmation
  end

  def admin?
    role == Role.admin
  end

  def company_rep?(id = nil)
    if admin?
      true
    elsif self.role == Role.rep
      if id == nil
        true
      elsif self.id == id
        true
      end
    end
  end

  def self.active
    all(active: true)
  end

  def self.inactive
    all(active: false)
  end

  def logo_url
    if self.img_url.blank?
      "/img/missing-image-640x360.png"
    else
      self.img_url
    end
  end
end
