5.times { Admin.create!(name: Faker::Name.name) }
5.times { User.create!(name: Faker::Name.name) }
5.times { AccountExecutive.create!(name: Faker::Name.name) }

AccountExecutive.all.each do |executive|
  5.times { executive.clients.create!(name: Faker::Name.name) }
end

# Add data to the search index
# https://github.com/ankane/searchkick
