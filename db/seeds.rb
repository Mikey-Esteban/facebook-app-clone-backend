require 'rest-client'

User.destroy_all


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

  users_image_urls << result['picture']['medium']
  users << user
end

5.times do |i|
  resp = RestClient.get "https://randomuser.me/api/?gender=female"
  obj = JSON.parse(resp)
  result = obj['results'][0]

  user = User.create({
    name: "#{result['name']['first']} #{result['name']['last']}",
    email: "email#{i+5}@email.com",
    password: 'password'
  })

  users_image_urls << result['picture']['medium']
  users << user
end

users_image_urls.each_with_index do |image_url, index|
  user = users[index]
  puts user
  profile = Profile.create({
    bio: '[insert bio here]',
    image_url: image_url,
    user_id: user.id
  })
end
