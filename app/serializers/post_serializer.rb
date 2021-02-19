class PostSerializer
  include JSONAPI::Serializer
  attributes :text, :user_id, :likes, :comments
end
