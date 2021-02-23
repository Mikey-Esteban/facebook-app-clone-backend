require 'rest-client'

User.destroy_all

female_collection = Unsplash::Collection.find("42582960")
female_photos_collection = female_collection.photos
male_collection = Unsplash::Collection.find("69656559")
male_photos_collection = male_collection.photos

users = []
users_image_urls = []
5.times do |i|
  resp = RestClient.get "https://randomuser.me/api/?gender=female"
  obj = JSON.parse(resp)
  result = obj['results'][0]

  user = User.create({
    name: "#{result['name']['first']} #{result['name']['last']}",
    email: "email#{i}@email.com",
    password: 'password'
  })

  users << user
end

5.times do |i|
  resp = RestClient.get "https://randomuser.me/api/?gender=male"
  obj = JSON.parse(resp)
  result = obj['results'][0]

  user = User.create({
    name: "#{result['name']['first']} #{result['name']['last']}",
    email: "email#{i+5}@email.com",
    password: 'password'
  })

  users << user
end

female_photos_collection.each_with_index do |photo, i|
  puts photo
  user = users[i]
  profile = Profile.create({
    bio: '[insert bio here]',
    image_url: photo['urls']['small'],
    user_id: user.id
  })
end

male_photos_collection.each_with_index do |photo, i|
  user = users[i+5]
  profile = Profile.create({
    bio: '[insert bio here]',
    image_url: photo['urls']['small'],
    user_id: user.id
  })
end
