Fabricator(:company) do
  name         { [Faker::Company.name, *Faker::Lorem.words(2).map(&:capitalize)].join(' ' ) }
  created_at   { DateTime.now }
  img_url      { "wwww.img-url.com" }
  
end
