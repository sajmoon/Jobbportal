require 'spec_helper'

describe "JobPresenter" do
  let(:company) { Fabricate :company }
  let(:job) { Fabricate(:job, apply_url: "", company: company).extend(JobPresenter) }

  it { expect(job.apply_link).to include "mailto:" }
end
