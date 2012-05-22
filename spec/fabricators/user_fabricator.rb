Fabricator(:user) do
  first_name      { Faker::Name.name}
  last_name       { Faker::Name.name}
  email           { Faker::Internet.email }
  salt            { "new_salt" }
  created_at      { Time.now }
  expires_at      { Time.local(2014,"jan",1,20,15,1) }
end
