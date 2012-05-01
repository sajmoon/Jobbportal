Fabricator(:category) do
  name      { [Faker::Company.name, *Faker::Lorem.words(1).map(&:capitalize)].join(' ') }
end
