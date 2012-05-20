class Category
  include DataMapper::Resource

  property :id, 	Serial
  property :name, Text, required: true

  validates_uniqueness_of :name
  has n, :jobs, :through => Resource
end

