require 'sinatra/reloader'
class Job
  include DataMapper::Resource

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
  property :company_id,         Integer,  required: true
  property :starttime,          Date
  property :endtime,            Date

  has n, :categories, :through => Resource

  belongs_to :company

  def display_categories
    self.categories.map(&:name).join(", ")
  end

  def formated_description
    RedCloth.new(self.description).to_html
  end

  def self.has_started
    all(:starttime.lte => Date.today)
  end

  def self.not_started
    all(:starttime.gt => Date.today)
  end

  def self.not_ended
    all(:endtime.gte => Date.today) + all(:endtime => "")
  end

  def self.has_ended
    all(:endtime.lt => Date.today)
  end

  def self.is_active
    all(active: true) 
  end

  def self.running_now
    all.is_active.has_started.not_ended
  end

  def is_new
    true
  end
end
