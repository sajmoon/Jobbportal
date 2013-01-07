require "feature_spec_helper"

describe "not requiring sign in" do

  it "redners root url" do
    visit "/"
    page.must_have_content "Senaste jobben"
  end

  it "renders show for job" do
    company = Fabricate :company
    job = Fabricate :job, company: company
    visit "/jobs/#{job.id}/"

    page.must_have_content job.title
  end
end

describe "requires sign in" do
  it "admin fails" do
    visit "/admin"
    page.must_have_content "Du ska inte se detta"  
  end
end
