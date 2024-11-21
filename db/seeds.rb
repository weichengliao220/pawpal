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
require 'open-uri'

puts "Cleaning database..."
Review.destroy_all
Booking.destroy_all
Petsitter.destroy_all
User.destroy_all

# Array of pet types and their breeds
PETS = {
  "dog" => ["Labrador", "German Shepherd", "Golden Retriever", "Bulldog", "Poodle"],
  "cat" => ["Persian", "Siamese", "Maine Coon", "British Shorthair", "Ragdoll"],
  "bird" => ["Parrot", "Canary", "Cockatiel", "Budgie", "Finch"],
  "fish" => ["Goldfish", "Betta", "Guppy", "Tetra", "Angel Fish"]
}

# Function to get random pet-related image URL from Unsplash
def random_pet_image
  [
    "https://images.unsplash.com/photo-1517849845537-4d257902454a?w=300",
    "https://images.unsplash.com/photo-1518717758536-85ae29035b6d?w=300",
    "https://images.unsplash.com/photo-1530281700549-e82e7bf110d6?w=300",
    "https://images.unsplash.com/photo-1548199973-03cce0bbc87b?w=300",
    "https://images.unsplash.com/photo-1537151608828-ea2b11777ee8?w=300"
  ].sample
end

puts "Creating users and petsitters..."

1.times do |i|
  user = User.create!(
    email: 'test@gmail.com',
    password: 'testtest',
    username: 'test_user',
    pets: PETS.keys.sample(rand(1..3)).join(", "),
    address: Faker::Address.full_address,
    avatar: Faker::Avatar.image
  )

  # Make some users petsitters (70% chance)

  begin
    file = URI.open(random_pet_image)
    petsitter = Petsitter.create!(
      user: user,
      price: rand(20..100) * 100,
      bio: Faker::Lorem.paragraph(sentence_count: 3),
      acceptable_pets: PETS.keys.sample(rand(1..4)).join(", ")
    )
    petsitter.photo.attach(io: file, filename: "petsitter_#{i}.jpg", content_type: "image/jpeg")
  rescue OpenURI::HTTPError => e
    puts "Skipping image attachment for petsitter #{i} due to error: #{e.message}"
    next
  end
end

# Create 20 users, some of which will be petsitters
20.times do |i|
  user = User.create!(
    email: Faker::Internet.unique.email,
    password: 'password123',
    username: Faker::Internet.unique.username,
    pets: PETS.keys.sample(rand(1..3)).join(", "),
    address: Faker::Address.full_address,
    avatar: Faker::Avatar.image
  )

  # Make some users petsitters (70% chance)
  if rand < 0.7
    begin
      file = URI.open(random_pet_image)
      petsitter = Petsitter.create!(
        user: user,
        price: rand(20..100) * 100,
        bio: Faker::Lorem.paragraph(sentence_count: 3),
        acceptable_pets: PETS.keys.sample(rand(1..4)).join(", ")
      )
      petsitter.photo.attach(io: file, filename: "petsitter_#{i}.jpg", content_type: "image/jpeg")
    rescue OpenURI::HTTPError => e
      puts "Skipping image attachment for petsitter #{i} due to error: #{e.message}"
      next
    end
  end
end

puts "Creating bookings and reviews..."

# Get all petsitters and users
petsitters = Petsitter.all
users = User.all

# Create bookings and reviews
petsitters.each do |petsitter|
  # Create 8-12 bookings for each petsitter
  rand(8..12).times do
    # Select a random user who isn't the petsitter
    booking_user = users.reject { |u| u == petsitter.user }.sample

    # Create a booking with more past dates to ensure more reviews
    start_date = Faker::Date.between(from: 6.months.ago, to: 2.months.from_now)
    booking = Booking.create!(
      user: booking_user,
      petsitter: petsitter,
      start_date: start_date,
      end_date: start_date + rand(1..7).days,
      status: %w[pending accepted declined].sample,
      location: [true, false].sample
    )

    # Create reviews only for completed bookings
    if booking.status == 'accepted' && booking.end_date < Date.today && rand < 0.9
      Review.create!(
        user: booking_user,
        petsitter: petsitter,
        booking: booking,
        rating: rand(1..5),
        comment: Faker::Lorem.paragraph(sentence_count: 2)
      )
    end
  end
end

puts "Seeding completed!"
puts "Created #{User.count} users"
puts "Created #{Petsitter.count} petsitters"
puts "Created #{Booking.count} bookings"
puts "Created #{Review.count} reviews"
