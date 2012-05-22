require 'spec_helper'

describe Company do
  let(:company) { Fabricate(:company)}
  it 'can be created' do 
    company.must_be_instance_of(Company)
  end

  it "is valid" do
    company.valid?.must_equal true
  end

  describe "company user interactions" do
    let (:user1) { Fabricate(:user) }
    let (:user2) { Fabricate(:user) }

    it "can has many users" do
      company.users.count.must_equal 0
      company.users << user1
      company.save!

      user1.company.name.must_equal company.name
      user1.company.nil?.must_equal false
    end
  end
end