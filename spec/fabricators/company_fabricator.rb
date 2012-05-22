Fabricator(:company) do
  name         { Faker::Name.name }
  created_at   { Time.now }
  img_url      { "wwww.img-url.com" }
end
