Fabricator(:job) do 
  title         { Faker::Name.name }
  short_description     { "This is a short description"}
  description           { " Long desc" }
  created_at    { Time.now }
  updated_at    { Time.now }
  active        { true }
  apply_url     { Faker::Internet.url }
  starttime     { Date.today }
  weeks         { 2 }
end
