require "spec_helper"

describe "JobPresenter" do
  before do
    company = Fabricate :company
    job = Fabricate :job, apply_url: "", company: company
    @jobpresenter = job.extend(JobPresenter)
  end

  it { expect(@jobpresenter.apply_link).to include "mailto:" }
end
