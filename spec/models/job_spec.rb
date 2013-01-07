require 'spec_helper'

describe Job do 
  let (:company) { Fabricate(:company) }
  let (:category1) { Fabricate(:category) }
  
  after :each do
    Job.destroy
    CategoryJob.destroy
    Company.destroy
  end

  it "make simple job object" do
    job = Fabricate :job
    job.company = company
    job.save
    job.errors.each do |e| 
      e.must_equal "simon"
      end
    job.valid?.must_equal true
  end

  it 'can be created' do
    job = Fabricate(:job, company: company )
    job.must_be_instance_of(Job)
    job.save
    job.valid?.must_equal true
  end

  it 'is assosicated with a company' do
    job = Fabricate(:job, company: company)
    job.company = company
    job.save!
    company.jobs.count.must_equal 1
    company.jobs.first.must_be_instance_of(Job)
    job.company.must_be_instance_of(Company)
  end
  
  it "must not have any errors" do
    job = Fabricate(:job, company: company)
    job.errors.count.must_equal 0
  end

  it "has endtime" do
    job = Fabricate(:job, company: company)
    job.endtime.must_equal ( job.starttime + 7*job.weeks )
  end

  it "is valid" do
    job = Fabricate(:job, company: company)
    Job.count.must_equal 1
    job.errors.count.must_equal 0
    job.valid?.must_equal true
  end
end
