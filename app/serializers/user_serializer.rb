class UserSerializer
  include JSONAPI::Serializer
  attributes :id, :email, :name, :jti, :created_at, :friendships, :posts

  attribute :created_date do |user|
         user && user.created_at.strftime('%d/%m/%Y')
  end

  has_many :sent_friend_requests, serializer: FriendRequestSerializer
end
