Fabricator(:job) do
  title             { Faker::Name.name }
  short_description { "This is a short description" }
  description       { "Long desc" }
  active            { true }
  apply_url         { Faker::Internet.url }
  starttime         { Date.today - 1 }
  weeks             { 2 }
end
