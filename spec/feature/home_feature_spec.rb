require "feature_spec_helper"

describe "home screen" do
  it "should render home screen" do
    visit "/"

    page.must_have_content "Senaste jobben"
  end
end
