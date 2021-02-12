User.destroy_all

users = []
10.times do |i|
  user = User.create({
    name: Faker::FunnyName.name,
    email: "email#{i}@email.com",
    password: 'password'
  })
  users << user
end
