class User
  include DataMapper::Resource
  include DataMapper::Validate
  include LDAPLookup::Importable

  attr_accessor :password, :password_confirmation

  # Properties
  property :id,               Serial
  property :ugid,             String, required: true, unique: true
  property :first_name,       String, required: true
  property :last_name,        String, required: true
  property :role,             String, default: ""
  property :expires_at,       Date

  # Validations
  validates_format_of        :role,     :with => /[A-Za-z]/

  def self.find_or_create_from_ldap(ugid)
    user = User.first(ugid: ugid)

    unless user
      user = User.from_ldap(ugid: ugid)
      user.expires_at = Date.today + 365
      user.save!
    end
    
    user
  end

  def name
    [first_name, last_name].join(' ')
  end

  def to_s
    name
  end

  def active?
    self.expires_at >= Date.today
  end
end

