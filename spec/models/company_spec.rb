require 'spec_helper'

describe Company do

  describe "basic" do
    let(:company) { Fabricate :company }

    it { expect(company).to be_instance_of(Company) }
    it { expect(company.errors.count).to eq 0 }
    it { expect(company.valid?).to eq true }
    it { expect(company.salt).not_to be_blank }
  end

  describe "authentication" do
    let(:company) { Fabricate(:company) }

    it { expect(company.id).not_to be_nil }
    it { expect(company.role).to eq(Role.rep) }
    it { expect(company.salt).not_to be_blank }
    it { expect(company.hashedpassword).not_to be_blank }
    it { expect(company.errors.count).to eq 0 }

    it "update password with no new info" do
      company.password = ""
      company.password_confirmation = ""
      expect(company.should_update_password?).to be_falsey
    end

    describe "updateing password" do
      before do
        company.password = "newpassword"
        company.password_confirmation = "newpassword"
      end

      it { expect(company.should_update_password?).to be_truthy }
      it { expect(company.new_password_should_match).to be_truthy }
    end

    describe "need both password and confirmation" do
      let(:company) { Fabricate :company, password_confirmation: "" }

      it { expect(company.should_update_password?).to be_truthy }
      it { expect(company.new_password_should_match).to be_falsey }
    end

    it "salt changes when we set a new password" do
      old_salt = company.salt
      company.password = "newpassword"
      company.password_confirmation = "newpassword"

      company.save

      expect(company.should_update_password?).to be_truthy
      expect(company.salt).not_to eq(old_salt)
    end

    it "two companies should have differnet salts" do
      company1 = Fabricate :company
      company2 = Fabricate :company

      expect(company1.salt).not_to eq(company2.salt)
      expect(company1.hashedpassword).not_to eq(company2.hashedpassword)
    end

    describe "validate" do
      it { expect(company.checkpassword("wrong password")).to be_falsey }
      it { expect(company.checkpassword("password")).to be_truthy }
    end
  end

  describe "role" do
    describe "admin" do
      let(:company) { Fabricate(:company, role: Role.admin) }

      it { expect(company.admin?).to be_truthy }
      it { expect(company.company_rep?).to be_truthy }
    end

    describe "Company representative" do
      let(:company) { Fabricate(:company) }
      let(:second_company) { Fabricate(:company) }

      it { expect(company.company_rep?).to be_truthy }
      it { expect(company.company_rep?(second_company.id)).to be_falsey }
    end
  end
end
