Fabricator(:company) do
  name            { Faker::Name.name }
  img_url         { "wwww.img-url.com" }
  salt            { "salt" }
  email           { "email1@d.kth.se" }
  password        { "password" }
  password_confirmation { "password" }
end
