require 'rest-client'
User.destroy_all

def create_post_text
  Faker::Lorem.paragraph(sentence_count: 2, supplemental: false, random_sentences_to_add: 7)
end

def create_comment_text
  Faker::Lorem.paragraph
end

female_photos_collection = Unsplash::Collection.find("42582960").photos
male_photos_collection = Unsplash::Collection.find("69656559").photos

all_photos = female_photos_collection + male_photos_collection
users = []
bios = [
  'Will go into survival mode if tickled.',
  'Pretty much just pictures of food and my dog.',
  'Anything but predictable.',
  'A day in the life of me: Eat avocado toast, post Instagram videos, read Instagram comments.',
  'Your life does not get better by chance. It gets better by a change.',
  'First I drink the coffee. Then I do the things.',
  'Don’t go bacon my heart.',
  '*Insert clever bio here*',
  '🐦: (twitter handle) 👻: (snapchat handle) 🎥: (youtube handle) Made in 🇬🇧.',
  'Simple but significant.'
]

all_photos.each_with_index do |photo, index|
  resp = RestClient.get "https://randomuser.me/api/?gender=female" if index < 5
  resp = RestClient.get "https://randomuser.me/api/?gender=male" if index >= 5
  obj = JSON.parse(resp)
  result = obj['results'][0]

  user = User.create({
    name: "#{result['name']['first']} #{result['name']['last']}",
    email: "email#{index}@email.com",
    password: 'password'
  })

  profile = Profile.create({
    bio: bios[index],
    image_url: photo['urls']['small'],
    user_id: user.id
  })

  users << user
end

# seed 50 posts with 0-5 comments each
50.times do
  user = users.sample
  post = Post.create({
    user_id: user.id,
    text: create_post_text
  })

  rand(0...6).times do
    commented_user = users.sample
    comment = Comment.create({
      user_id: commented_user.id,
      post_id: post.id,
      commenter: commented_user.name,
      text: create_comment_text
      })
  end

end
