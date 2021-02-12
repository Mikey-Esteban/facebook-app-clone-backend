class FriendRequestSerializer
  include JSONAPI::Serializer
  attributes :requestor_id, :receiver_id, :status
end
