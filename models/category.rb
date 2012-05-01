class Category
  include DataMapper::Resource

  property :id, 	Serial
  property :name, Text, required: true
	
  has n, :jobs, :through => Resource
end

