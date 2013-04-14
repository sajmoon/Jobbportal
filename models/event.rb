require 'date'
class Event
  include DataMapper::Resource
  include DataMapper::Validate

  property :id,           Serial
  property :title,        String,       required: true, default: ""
  property :starttime,    DateTime
  property :description,  Text

  #Relations
  property :company_id,   Integer

  validates_presence_of :title, :starttime

  belongs_to :company

  def self.not_passed
    all(:starttime.gte => Time.now)
  end

  def self.passed
    all(:starttime.lt => Time.now)
  end
end
