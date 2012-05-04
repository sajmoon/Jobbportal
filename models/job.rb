class Job
  include DataMapper::Resource

  # property <name>, <type>
  property :id,                 Serial
  property :title,              String,   required: true
  property :short_description,  Text,     required: true
  property :description,        Text,     required: true
  property :created_at,         DateTime, required: true
  property :updated_at,         DateTime, required: true
  property :active,             Boolean,  required: true, default: true

  has n, :categories, :through => Resource

  belongs_to :company
end
