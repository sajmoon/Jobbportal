require 'spec_helper'

describe Job do 
  let (:job) { Fabricate(:job) }
  let (:company) { Fabricate(:company) }
  let (:category1) { Fabricate(:category) }

  it 'can be created' do
    job.should be_instance_of(Job)
  end

  it 'is assosicated with a company' do
    job.company = company
    job.save!
    company.jobs.count.must_equal 1
    company.jobs.first.should be_instance_of(Job)
    job.company.should be_instance_of(Company)
  end

  it "can has no categories" do
    job.categories.count.must_equal 0
  end
end
