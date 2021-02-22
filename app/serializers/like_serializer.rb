class LikeSerializer
  include JSONAPI::Serializer
  attributes :user_id, :post_id
end
