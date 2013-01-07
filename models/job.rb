require 'date'
class Job
  include DataMapper::Resource
  include Sinatra::Authorization

  property :id,                 Serial
  property :title,              String,   required: true
  property :short_description,  Text,     required: true
  property :description,        Text,     required: true
  property :created_at,         Date,     required: true
  property :updated_at,         Date,     required: true
  property :active,             Boolean,  required: true, default: true
  property :viewcount,          Integer,  required: true, default: 0
  property :apply_url,          String,   required: true, default: ""
  property :created_by,         Integer,  required: true, default: 0
  property :company_id,         Integer,  required: true
  property :starttime,          Date,     required: true, default: lambda { |r, p| Date.now }
  property :endtime,            Date
  property :paid,               Boolean,  default: false
  property :paid_at,            Date
  property :total_cost,         Integer
  property :weeks,              Integer

  has n, :categories, :through => Resource

  belongs_to :company

  before :save do
    self.endtime = self.starttime + weeks*7
  end

  def self.desc
    all(:order => :created_at.desc )
  end

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
    all(:endtime.gte => Date.today)
  end

  def self.has_ended
    all(:endtime.lt => Date.today)
  end
  
  def self.is_paid
    all(paid: true)
  end

  def self.not_paid
    all(paid: false)
  end
  
  def self.is_active
    all(active: true) 
  end

  def self.running_now
    all.is_active.has_started.not_ended.desc
  end

  def is_new
    unless self.starttime.nil?
      if (self.starttime - Date.today).abs.to_i < 1
        true
      else
        false
      end
    end
  end

	def number_of_days
		(endtime - starttime).to_i
	end
end
