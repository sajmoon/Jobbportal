class Subscribe
  include DataMapper::Resource
  include DataMapper::Validate
  
  property :id, Serial
  property :email, String, required: true

  validates_uniqueness_of :email, :name
end
