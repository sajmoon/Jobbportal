require "feature_spec_helper"

describe "not requiring sign in" do

  before do
    Job.destroy
    Company.destroy
    CategoryJob.destroy
  end

  it "redners root url" do
    visit "/"
    page.must_have_content "Senaste jobben"
  end

  it "renders show for job" do
    company = Fabricate :company
    job = Fabricate :job, company: company
    job.save
    visit "/jobs/#{job.id}/"

    page.must_have_content job.title
  end
end

describe "if signed in as company1" do
  before :each do
    Company.destroy
    Job.destroy
    @company1 = Fabricate :company, name: "company1"
    @company2 = Fabricate :company, name: "company2"
    @job1 = Fabricate :job, company: @company1
    @job2 = Fabricate :job, company: @company2
    @job3 = Fabricate :job, company: @company2
    login_as @company1
  end

  after :each do
    logout
  end

  it "is signed in" do
    visit "/jobs"

    page.must_have_content "Din profil"
  end

  it "validates that test suite is setup ok" do
    Job.count.must_equal 3
    @company1.jobs.count.must_equal 1
    @company2.jobs.count.must_equal 2
  end

  it "can see all jobs in index page" do
    visit "/jobs/"

    [@job1, @job2, @job3].each do |job|
      page.must_have_content job.title
    end
  end
  
  it "may edit its own offers" do
    visit "/jobs/#{@job1.id}/edit"
    page.must_have_content "Webadress till extern sida"
  end

  it "may not edit others" do
    visit "/jobs/#{@job2.id}/edit"
    page.must_have_content "Du ska inte se detta"
    visit "/jobs/#{@job3.id}/edit"
    page.must_have_content "Du ska inte se detta"
  end

end

describe "fails if not signed in" do
  it "admin" do
    visit "/admin"
    page.must_have_content "Du ska inte se detta"  
  end

  describe "/jobs action" do
    before do
      Job.destroy
    end
    
    it "/edit" do
      @company = Fabricate :company
      @job = Fabricate :job, company: @company
      visit "/jobs/#{@job.id}/edit"

      page.must_have_content "Du ska inte se detta"  
    end

  end

  describe "/companies actions" do
    before do
      Company.destroy
      @company = Fabricate :company
    end

    it "/index" do
      visit "/companies"

      page.must_have_content "Du ska inte se detta"
    end

    it "/show" do
      visit "/companies/#{@company.id}"

      page.must_have_content "Du ska inte se detta"
    end

    it "/edit" do
      visit "/companies/#{@company.id}/edit"

      page.must_have_content "Du ska inte se detta"
    end
  end

  describe "/categories actions" do
    before do
      Category.destroy
      @category = Fabricate :category
    end

    it "/index" do
      visit "/categories/"
      page.must_have_content "Du ska inte se detta"
    end

    it "/show" do
    end

    it "/edit" do
      visit "/categories/#{@category.id}/edit"
      page.must_have_content "Du ska inte se detta"
    end
  end
end
