# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

require 'faker'

# Clear the database
Booking.destroy_all
Petsitter.destroy_all
User.destroy_all

# Create Users
10.times do
  user = User.create!(
    email: Faker::Internet.unique.email,
    password: 'password', # or any secure default
    username: Faker::Internet.username,
    pets: Faker::Creature::Animal.name,
    address: Faker::Address.full_address,
    avatar: Faker::Avatar.image
  )

  # Create Petsitters linked to Users
  petsitter = Petsitter.create!(
    user: user,
    price: rand(10..100),
    bio: Faker::Lorem.paragraph,
    picture_url: Faker::LoremFlickr.image(size: "300x300", search_terms: ['pets']),
    acceptable_pets: %w[dog cat bird fish].sample(rand(1..4)).join(", ")
  )

  # Create Bookings linked to Users and Petsitters
  3.times do
    start_date = Faker::Date.forward(days: rand(1..30))
    end_date = start_date + rand(1..7).days
    Booking.create!(
      user: user,
      petsitter: petsitter,
      start_date: start_date,
      end_date: end_date,
      status: %w[pending accepted declined].sample,
      location: [true, false].sample
    )
  end
end

puts "Seeded #{User.count} users, #{Petsitter.count} petsitters, and #{Booking.count} bookings!"
