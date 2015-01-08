class Subscribe
  include DataMapper::Resource
  include DataMapper::Validate

  property :id, Serial
  property :email, String, required: true

  validates_uniqueness_of :email, :name
  validates_format_of :email, as: :email_address
end
