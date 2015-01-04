require 'spec_helper'

describe Job do
  let (:company) { Fabricate(:company) }
  let (:category1) { Fabricate(:category) }

  it "make simple job object" do
    job = Fabricate :job, title: ""
    job.company = company
    job.save
    expect(job.valid?).to be false
    expect(job.errors).not_to be_blank

    expect(job.errors.keys).to include :title
    expect(job.valid?).to be_falsy
  end

  it 'can be created' do
    job = Fabricate(:job, company: company )
    expect(job).to be_instance_of(Job)
    job.save
    expect(job.valid?).to be true
  end

  it 'is assosicated with a company' do
    job = Fabricate(:job, company: company)
    job.company = company
    job.save!
    expect(company.jobs.count).to eq 1
    expect(company.jobs.first).to be_instance_of(Job)
    expect(job.company).to be_instance_of(Company)
  end

  it "must not have any errors" do
    job = Fabricate(:job, company: company)
    expect(job.errors.count).to eql 0
  end

  it "has endtime" do
    job = Fabricate(:job, company: company)
    expect(job.endtime).to eq ( job.starttime + 7*job.weeks )
  end

  it "is valid" do
    job = Fabricate(:job, company: company)
    expect(job.errors.count).to eq 0
    expect(job.valid?).to equal true
  end
end
