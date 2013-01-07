require 'spec_helper'

describe Company do

  after do
    Company.destroy
  end

  describe "with empty db" do
    it "has not companies" do
      Company.all.count.must_equal 0
    end
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
