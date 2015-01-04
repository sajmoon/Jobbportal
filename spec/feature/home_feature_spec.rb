require "feature_spec_helper"

describe "home screen" do
  it "should render home screen" do
    visit "/"

    expect(Company.all.count).to eq 0
    expect(page).to have_content "Inga lediga tjänster"
  end
end
