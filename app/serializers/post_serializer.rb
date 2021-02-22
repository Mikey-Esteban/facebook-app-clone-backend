class PostSerializer
  include JSONAPI::Serializer
  attributes :text, :user_id, :author, :likes, :comments, :created_at

  attribute :author do |post|
    author = User.find_by(id: post[:user_id])
    author.name
  end
end
