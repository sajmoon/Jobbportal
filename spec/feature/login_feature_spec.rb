require "feature_spec_helper"

describe "not requiring sign in" do
  it "redners root url" do
    visit "/"
    expect(page).to have_content "Inga lediga tjänster"
  end

  it "renders show for job" do
    company = Fabricate :company
    job = Fabricate :job, company: company

    visit "/jobs"
    expect(page).to have_content job.title

    visit "/jobs/#{job.id}/"
    expect(page).to have_content job.title
  end
end

def login_as_company(company)
  login_as_company_with_password(company, "password")
end

def login_as_company_with_password(company, password)
  visit "/auth/login"
  fill_in "company[email]", with: company.email
  fill_in "company[password]", with: password
  click_button "Logga in"

end

describe "if signed in as company" do
  before :each do
    @company1 = Fabricate :company, name: "company1"
    @company2 = Fabricate :company, name: "company2"
    @job1 = Fabricate :job, company: @company1
    @job2 = Fabricate :job, company: @company2
    @job3 = Fabricate :job, company: @company2
    login_as_company @company1
  end

  it "is signed in" do
    expect(page).to have_content @company1.name

    expect(page).to have_content "Min profil"
  end

  it "can see all jobs in index page" do
    visit "/jobs/"

    [@job1, @job2, @job3].each do |job|
      expect(page).to have_content job.title
    end
  end

  it "may edit its own offers" do
    visit "/jobs/#{@job1.id}/edit"
    expect(page).to have_content "Ändra din annons"
  end

  it "may not edit others" do
    visit "/jobs/#{@job2.id}/edit"
    expect(page).to have_content "Nu har du kommit fel"
    visit "/jobs/#{@job3.id}/edit"
    expect(page).to have_content "Nu har du kommit fel"
  end
end

describe "wrong password" do
  let(:company) { Fabricate(:company) }

  it "gives error" do
    visit "/"

    click_on "Logga in"

    fill_in "company[email]", with: company.email
    fill_in "company[password]", with: "wrong password"

    click_button "Logga in"

    expect(page).to have_content("Du kunde inte logga in")
  end
end

describe "fails if not signed in" do
  it "admin" do
    visit "/admin"
    expect(page).to have_content "Nu har du kommit fel!"
  end

  describe "/jobs action" do
    it "/edit" do
      @company = Fabricate :company
      @job = Fabricate :job, company: @company
      visit "/jobs/#{@job.id}/edit"

      expect(page).to have_content "Nu har du kommit fel!"
    end
  end

  describe "/companies actions" do
    before do
      @company = Fabricate :company
    end

    it "/index" do
      visit "/companies"

      expect(page).to have_content "Nu har du kommit fel"
    end

    it "/show" do
      visit "/companies/#{@company.id}"

      expect(page).to have_content "Nu har du kommit fel!"
    end

    it "/edit" do
      visit "/companies/#{@company.id}/edit"

      expect(page).to have_content "Nu har du kommit fel!"
    end
  end

  describe "/categories actions" do
    before do
      @category = Fabricate :category
    end

    it "/index" do
      visit "/categories/"
      expect(page).to have_content "Nu har du kommit fel"
    end

    it "/show"

    it "/edit" do
      visit "/categories/#{@category.id}/edit"
      expect(page).to have_content "Nu har du kommit fel"
    end
  end
end

describe "signed in user can change password" do
  before do
    @company = Fabricate(:company)
  end

  it "update password view renders" do
    login_as_company @company

    visit "/"

    expect(page).to have_content "Min profil"

    click_on "Min profil"

    expect(page).to have_content "Ändra detaljer om företaget"
    expect(page).to have_content "Byt lösenord"

    click_on "Byt lösenord"

    expect(page).to have_content "Ändra lösenord för "
    new_password = "somestupidstuff"

    fill_in "company[new_password]", with: new_password
    fill_in "company[confirm_password]", with: new_password

    click_on "Byt lösenord"

    click_on "Logga ut"

    expect(page).not_to have_content "Min profil"
    expect(page).to have_content "Utloggning lyckades"

    login_as_company @company
    expect(page).to have_content "Du kunde inte logga in"

    login_as_company_with_password @company, new_password

    expect(page).to have_content "Du har loggats in som "

    expect(page).to have_content "Min profil"
  end
end
