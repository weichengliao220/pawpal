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

# Clear the database
Booking.destroy_all
Petsitter.destroy_all
User.destroy_all

pictures_url = [
  "https://static1.pawshakecdn.com/next/headers/mobile/petsitters-pet-sitting-dog-sitting.webp",
  "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcT_F1HZ7_i0eVUZD4gckYCIXt7BuF58TjN-uMG2EVnP_SieHJdxH6DIJx5idNRatyMHi4Y&usqp=CAU",
  "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRWtvZ7yA_1gb9gAPAe9mB7MhM7ZJeYtxcaCKpBhnoGTWRUaKdmu1wNWx5tQpIMGye5oU4&usqp=CAU",
  "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSJJ3IRcVBvn0JsDmnG2flZsb6KHyLJD2SbcpBCM5IrdPwwor5urud9C8UJVE2QXPEgcLw&usqp=CAU",
  "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSnDJ39DjtTneAlSvVcP-DgRIrS8-SC8Qc6YduJK_OKKA2hmxGhSDgOQnXz6y792CBKu7s&usqp=CAU",
  "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTUcxY91I_I0aOOM_VF1_ljV6Kf6aKHpkxYP9X5yDMeSVQpy2y2x_RyMmmoez4M2xiJ8l8&usqp=CAU",
  "https://assets.petbacker.com/user-images/320/u_07c1c6aa68.66359d0f96167.jpg",
  "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRcV8BnQLHKrMeN9OYkx9zPvSneHMGSXijpX8MNjLZ4LPHof_zPjLgQQbygpJSP7X0Zbdk&usqp=CAU",
  "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTGuNmBnxk7hyMax_QqMBy1NgZ9BzK05m_lpHIUAFT8XApa9OAf635drVb2hSdVrBBUqQE&usqp=CAU",
  "https://www.akc.org/wp-content/uploads/2021/03/Dachshund-excited-to-snuggle-and-kiss-a-young-man-on-the-couch.jpeg",
  "https://www.grandrapidspetsitters.com/wp-content/uploads/2022/10/t-shirt-mockup-of-a-man-smiling-at-his-dog-18027.jpeg",
  "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQFc6xHrfQ18Hi2hlBqI0bKGuz8hzrALPlECtYsmMJkbcU4HxydtD6VFnsZ8ZuTgIiLofc&usqp=CAU",
  "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQvRV3oxlRKkigYj600nRoiHjZVKq3YY8_ePlWSW2XL6CZ8Gus6o577s429WasOP_v7nIc&usqp=CAU",
  "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTWt2qetvLBrATVZKOxhw9AAs2ao51qqc7-Ug&s",
  "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTrxYBcIGGuJewK8jMtiNBt260aUl7-ZOMbEZGwwdIu-MxsiUiE5a0H7zs6iz9gSVcs2Tw&usqp=CAU",
  "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRSSAWReslyHpk_96rEupJcr026RtTlJu-dzW1BEKRsEEgdzk8oaXAuDrFmuamnJgg9M8A&usqp=CAU",
  "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQmLorHmpJy8G9x7G82ITuZtiI-xxmQ2irMHA&s",
  "https://media.graphassets.com/resize=height:360,width:1280/output=format:webp/YPwwfONKR5GaADHjEIme?width=1280",
  "https://fetchpetcare.com/wp-content/uploads/2023/12/unconditional-love.jpg",
  "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcT_4rNjsE1sQ7IXfzjEUK34s_TWRqsK9pHicmIpGg0i1t2ibMJCkdDPwvgLL2wJVruRuxA&usqp=CAU"
]

# Create Users
20.times do
  user = User.create!(
    email: Faker::Internet.unique.email,
    password: 'password', # or any secure default
    username: Faker::Internet.username,
    pets: Faker::Creature::Animal.name,
    address: Faker::Address.full_address,
    avatar: Faker::Avatar.image
  )

  # Create Petsitters linked to Users
  file = URI.parse(pictures_url.sample).open
  petsitter = Petsitter.create!(
    user: user,
    price: rand(2..6) * 500,
    bio: Faker::Lorem.paragraph,
    rating: Petsitter::VALID_RATINGS.sample.to_f,
    address: %w[shinjuku shibuya meguro shinagawa roppongi].sample,
    acceptable_pets: %w[dog cat bird fish].sample(rand(1..4)).join(", ")
  )

  petsitter.photo.attach(io: file, filename: "file", content_type: "image/png")


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
