require 'spec_helper'

describe Company do

  before do
    Company.destroy
    Job.destroy
  end

  describe "basic" do
    let(:company) { Fabricate :company }

    it { company.must_be_instance_of(Company) }

    it "should not have any errors" do
      company.errors.each do |e|
        e.must_equal "simon"
      end
      company.errors.count.must_equal 0
    end

    it "is valid" do
      company.valid?.must_equal true
    end
  end
end
