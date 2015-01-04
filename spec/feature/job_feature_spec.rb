require "feature_spec_helper"

describe Job do
  it "create a new Job" do
    @company = Fabricate(:company)
    login_as @company

    visit "/jobs/new"

    expect(page).to have_content "Min profil"

    expect(page).to have_content "Skapa en ny annons"

    job = Fabricate.build :job

    fill_in("Titel", with: job.title)
    fill_in("Kort beskrivning", with: job.short_description)
    fill_in("job_description", with: :descripton )
    fill_in("job_apply_url", with: :apply_url )

    click_button("Spara")

    expect(page).to have_content job[:title]
    expect(Job.count).to eq 1
  end

  it "we can go to /edit" do
    @company = Fabricate :company
    login_as @company

    job = Fabricate :job, company: @company

    visit "/"

    expect(page).to have_content job.title
    visit "/jobs/#{job.id}/edit"

    expect(page).to have_content "ndra din annons"
  end
end
