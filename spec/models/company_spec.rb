require 'spec_helper'

describe Company do

  before do
    Company.destroy
    Job.destroy
  end

  describe "basic" do
    let(:company) { Fabricate :company }

    it { expect(company).to be_instance_of(Company) }

    it "should not have any errors" do
      expect(company.errors.count).to eq 0
    end

    it "is valid" do
      expect(company.valid?).to eq true
    end
  end
end
