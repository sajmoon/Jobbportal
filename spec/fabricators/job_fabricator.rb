Fabricator(:job) do 
  title     { Faker::Name.name }
  short_description     { "This is a short description"}
  description           { 
                "h1. Give RedCloth a try!
                A *simple* paragraph with
                a line break, some _emphasis_ and a 
                * an item
                * and another" }
  created_at    { Time.now }
  updated_at    { Time.now }
  active        { true }
  apply_url     {"www.#{ %w(dn aftonbladet hamsterpaj).sample }.se"}
end