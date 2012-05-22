require 'digest/sha2'
class User
  include DataMapper::Resource
  include DataMapper::Validate

  attr_accessor :password, :password_confirmation

  # Properties
  property :id,               Serial
  property :first_name,       String, required: true
  property :last_name,        String, required: true, default: ""
  property :email,            String, required: true, :format => :email_address
  property :role,             String, default: ""
  property :hashedpassword,   String, required: true
  property :salt,	            String, required: true
  property :expires_at,       Date
  property :created_at,       Date

  # Validations
  validates_format_of        :role,     :with => /[A-Za-z]/

  belongs_to :company,        :required => false

  def new_salt
    salt = (0..16).to_a.map{|a| rand(16).to_s(16)}.join
  end

  def name
    [first_name, last_name].join(' ')
  end

  def to_s
    name
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

  def active?
    if DateTime.now - self.expires_at < 1
      false
    else
      true
    end
  end
end

