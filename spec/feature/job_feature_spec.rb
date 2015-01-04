require "feature_spec_helper"

describe Job do
  it "create a new Job" do
    @company = Fabricate(:company)
    login_as @company

    visit "/jobs/new"

    expect(page).to have_content "Min profil"

    expect(page).to have_content "Skapa en ny annons"

    job = Fabricate.build :job, company: @company

    fill_in_job_form(job)

    click_button("Spara")
    expect(page).to have_content "skapades"
    expect(page).to have_content job[:title]
    expect(Job.count).to eq 1

    expect(page).to have_content "Ny!"
  end

  it "we can go to /edit" do
    @company = Fabricate :company
    login_as @company

    job = Fabricate :job, company: @company

    visit "/"

    expect(page).to have_content job.title
    visit "/jobs/#{job.id}/edit"

    expect(page).to have_content "Ändra din annons"

    job.title = "New title"
    fill_in_job_form job
    click_button "Spara"

    expect(page).to have_content "uppdaterades"
    expect(page).to have_content("New title")

    expect(Job.all.count).to eq 1
  end

  it "i can retry when validations fail" do
    @company = Fabricate :company
    login_as @company
    job = Job.new
    visit "/jobs/new"

    fill_in_job_form(job)

    click_button "Spara"

    expect(page).to have_content "Annonsen kunde inte"
    expect(page).to have_content "Det behövs en titel"
    expect(page).to have_content "Det behövs en kort beskrivning"
    expect(page).to have_content "Det behövs en beskrivning"

  end

  def fill_in_job_form(job)
    fill_in("job_title", with: job.title)
    fill_in("Kort beskrivning", with: job.short_description)
    fill_in("job_description", with: job.description)
    fill_in("job_apply_url", with: job.apply_link)
  end
end
