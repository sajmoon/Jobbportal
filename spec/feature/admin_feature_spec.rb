require "feature_spec_helper"
require "support/features/session_helpers"

describe "Siging in as admin" do

  before do
    @company = Fabricate(:company, role: Role.admin)

    visit "/"

    sign_in_with(@company.email, "password")

    expect(page).to have_content "Admin"

    click_link "Admin"

    expect(page).to have_content "Admin view"
  end

  it "admin can list companies" do

    given_we_have_three_companies

    click_on "Företag"

    3.times { |n| expect(page).to have_content "Company nr#{n}" }
  end

  it "can add a new company representative" do
    click_on "Företag"
    expect(page).to have_content "Företag"
    expect(page).to have_content "Inaktiverade företag"

    click_on "Nytt företag"

    expect(page).to have_content "Lägg till ett företag"

    fill_in "company[name]", with: "the company name"
    fill_in "company[email]", with: "example@example.com"
    fill_in "company[password]", with: "comp_password"
    fill_in "company[img_url]", with: "www.example.com/imgurl"

    click_button "Skapa"

    expect(page).to have_content "Nytt företag skapat!"

    click_link "Ändra"

    expect(page).to have_content "Ändra detaljer om företaget"
  end
end

def given_we_have_three_companies
  3.times { |n| Fabricate(:company, name: "Company nr#{n}") }
end

def sign_in_with(email, password)
  visit "/auth/login"

  fill_in "company[email]", with: email
  fill_in "company[password]", with: password
  click_button "Logga in"
end
