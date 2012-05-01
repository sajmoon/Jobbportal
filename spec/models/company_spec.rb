require 'spec_helper'

describe Company do
  describe "count of jobs" do
    let (:company) { Fabricate.build :company }

    let (:job) { Fabricate.build :job }

    it "counts to 0" do
      company.jobs.count.must_equal 0
    end
  end
end
