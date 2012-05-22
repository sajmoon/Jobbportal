require 'spec_helper'

describe User do
  let(:user) { Fabricate(:user) }

  it 'can be created' do
    user.must_be_instance_of(User)
  end

  it "is valid" do
    user.hashedpassword = user.encryptpassword("password", user.salt )
    user.valid?.must_equal true
  end

  %w[first_name last_name email salt].each do |attribute|
    it "is invalid without #{attribute}" do
      user.send("#{attribute}=", nil)
      user.valid?.must_equal false
    end
  end

  describe "testing roles" do
    it "admin" do
      user.role = Role.admin
      user.role.must_equal Role.admin
    end

    it "company rep" do
      user.role = Role.rep
      user.role.must_equal Role.rep
    end
  end
end