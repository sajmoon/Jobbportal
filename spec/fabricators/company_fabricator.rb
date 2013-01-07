Fabricator(:company) do
  name                  { Faker::Name.name }
  img_url               { "wwww.img-url.com" }
  salt                  { "salt" }
  email                 { Faker::Internet.email }
  password              { "password" }
  password_confirmation { "password" }
  role                  { Role.rep }
end
