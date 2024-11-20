# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

Booking.destroy_all
Petsitter.destroy_all
User.destroy_all

users_data = [
  {
    username: "John",
    email: "test@gmail.com",
    pets: "dog",
    address: "25 rue de la paix, 75001 Paris",
    password: "testpassword"
  },
  {
    username: "Patrick",
    email: "test2@gmail.com",
    pets: "bird",
    address: "26 rue de la paix, 75001 Paris",
    password: "testpassword"
  }
]

users_data.each do |user_data|
  user = User.create!(user_data)
  petsitter = Petsitter.create!(
    user_id: user.id,
    price: 10,
    bio: "I love animals",
    picture_url: "https://www.google.com",
    acceptable_pets: user_data[:pets]
  )
  Booking.create!(
    user_id: user.id,
    petsitter_id: petsitter.id,
    start_date: "2024-11-19",
    end_date: "2024-11-20",
    status: "pending",
    location: true
  )
end
