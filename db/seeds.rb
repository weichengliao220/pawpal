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

ADDRESSES = ["shinjuku", "shibuya", "shinagawa", "meguro", "roppongi"]

# Function to get random pet-related image URL from Unsplash
picture_urls = [
  "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcT_F1HZ7_i0eVUZD4gckYCIXt7BuF58TjN-uMG2EVnP_SieHJdxH6DIJx5idNRatyMHi4Y&usqp=CAU",
  "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRWtvZ7yA_1gb9gAPAe9mB7MhM7ZJeYtxcaCKpBhnoGTWRUaKdmu1wNWx5tQpIMGye5oU4&usqp=CAU",
  "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSJJ3IRcVBvn0JsDmnG2flZsb6KHyLJD2SbcpBCM5IrdPwwor5urud9C8UJVE2QXPEgcLw&usqp=CAU",
  "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSnDJ39DjtTneAlSvVcP-DgRIrS8-SC8Qc6YduJK_OKKA2hmxGhSDgOQnXz6y792CBKu7s&usqp=CAU",
  "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTUcxY91I_I0aOOM_VF1_ljV6Kf6aKHpkxYP9X5yDMeSVQpy2y2x_RyMmmoez4M2xiJ8l8&usqp=CAU",
  "https://assets.petbacker.com/user-images/320/u_07c1c6aa68.66359d0f96167.jpg",
  "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRcV8BnQLHKrMeN9OYkx9zPvSneHMGSXijpX8MNjLZ4LPHof_zPjLgQQbygpJSP7X0Zbdk&usqp=CAU",
  "https://www.akc.org/wp-content/uploads/2021/03/Dachshund-excited-to-snuggle-and-kiss-a-young-man-on-the-couch.jpeg",
  "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQvRV3oxlRKkigYj600nRoiHjZVKq3YY8_ePlWSW2XL6CZ8Gus6o577s429WasOP_v7nIc&usqp=CAU",
  "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTWt2qetvLBrATVZKOxhw9AAs2ao51qqc7-Ug&s",
  "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTrxYBcIGGuJewK8jMtiNBt260aUl7-ZOMbEZGwwdIu-MxsiUiE5a0H7zs6iz9gSVcs2Tw&usqp=CAU",
  "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRSSAWReslyHpk_96rEupJcr026RtTlJu-dzW1BEKRsEEgdzk8oaXAuDrFmuamnJgg9M8A&usqp=CAU",
  "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQmLorHmpJy8G9x7G82ITuZtiI-xxmQ2irMHA&s",
  "https://media.graphassets.com/resize=height:360,width:1280/output=format:webp/YPwwfONKR5GaADHjEIme?width=1280",
  "https://fetchpetcare.com/wp-content/uploads/2023/12/unconditional-love.jpg",
  "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcT_4rNjsE1sQ7IXfzjEUK34s_TWRqsK9pHicmIpGg0i1t2ibMJCkdDPwvgLL2wJVruRuxA&usqp=CAU",
  "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRAkQ86rCHtXYGGyX8P9xjwodbu2iiIuzgWuFnGMGEehglbrnc0_PBe3pOw50dsI9JkCGc&usqp=CAU",
  "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSskdoV_q04COuh3-XQhHtYYY3yeCDTFyDg4r5IGRwnXAeoyosVZCAdfwTk_HiXCjEoa8Y&usqp=CAU",
  "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcS8lsAvSkJrarUkyK5uKkuCslSbQ__8OYRjXMP6fcBuPL6gQVkyUsdHwLA0LeAJ0rCayn8&usqp=CAU",
  "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTpN5HLnqKfUCHLwRs3cNSGyk1wgcaY03I_iUT0wPOKEHXSTxkiaUOO5LgqfaQB6_qFSqE&usqp=CAU"
]

def random_pet_image(pictures)
  sampled_picture = pictures.sample
  pictures.delete(sampled_picture)
end

puts "Creating users and petsitters..."

1.times do |i|
  user = User.create!(
    email: 'test@gmail.com',
    password: 'testtest',
    username: 'test_user',
    pets: PETS.keys.sample(rand(1..3)).join(", "),
    address: Faker::Address.full_address,
    avatar: Faker::Avatar.image,
    phone_number: "0785425253"
  )

  # Make some users petsitters (70% chance)

  begin
    file = URI.open(random_pet_image(picture_urls))
    petsitter = Petsitter.create!(
      user: user,
      price: rand(20..100) * 100,
      bio: Faker::Lorem.paragraph(sentence_count: 3),
      acceptable_pets: PETS.keys.sample(rand(1..4)).join(", "),
      # address: ADDRESSES.sample
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
    address: ADDRESSES.sample,
    avatar: Faker::Avatar.image
  )

  # Make some users petsitters (70% chance)
  if rand < 0.7
    begin
      p url = random_pet_image(picture_urls)
      file = URI.open(url)
      petsitter = Petsitter.create!(
        user: user,
        price: rand(20..100) * 100,
        bio: Faker::Lorem.paragraph(sentence_count: 3),
        acceptable_pets: PETS.keys.sample(rand(1..4)).join(", "),
        # address: ADDRESSES.sample
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
