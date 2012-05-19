require 'digest/sha2'
class User
  include DataMapper::Resource
  include DataMapper::Validate

  attr_accessor :password, :password_confirmation

  # Properties
  property :id,               Serial
  property :ugid,             String
  property :first_name,       String, required: true
  property :last_name,        String, required: true
  property :email,            String, required: true
  property :role,             String, default: ""
  property :hashedpassword,   String, required: true
  property :salt,	            String, required: true
  property :expires_at,       Date

  # Validations
  validates_format_of        :role,     :with => /[A-Za-z]/

  belongs_to :company,        required: false

  def new_salt
    "newsalt"
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
    true
  end
end

