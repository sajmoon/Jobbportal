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
  property :viewcount,          Integer,  required: true, default: 0
  property :apply_url,          String,   required: true, default: ""
  property :created_by,         Integer,  required: true, default: 0

  has n, :categories, :through => Resource

  belongs_to :company


  def display_categories
    self.categories.map(&:name).join(", ")
  end

  def formated_description
    RedCloth.new(self.description).to_html
  end
end
