require "feature_spec_helper"

describe Job do
  before do
    Job.destroy
    Category.destroy
    CategoryJob.destroy
    Company.destroy
  end

  after do
    Job.destroy
    Category.destroy
    CategoryJob.destroy
    Company.destroy
  end

  it "create a new Job" do
    @company = Fabricate :company
    login_as @company

    visit "/jobs/new"

    page.must_have_content "Min profil"

    page.must_have_content "Skapa en ny annons"

    job = Fabricate.attributes_for :job

    fill_in("Titel", with: :title)
    fill_in("Kort beskrivning", with: :short_description )
    fill_in("job_description", with: :descripton )
    fill_in("job_apply_url", with: :apply_url )

    click_button("Spara")

  end

  it "we can go to /edit" do
    @company = Fabricate :company
    login_as @company

    job = Fabricate :job, company: @company
    visit "/jobs/#{job.id}/edit"

    page.must_have_content "ndra din annons"
  end
end
