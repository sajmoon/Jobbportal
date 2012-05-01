class Company
  include DataMapper::Resource

  property :id,         Serial
  property :name,       String,   required: true
  property :created_at, DateTime, required: true, default: DateTime.now
  property :img_url,    String

  has n, :jobs
end
