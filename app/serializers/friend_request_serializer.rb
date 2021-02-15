class FriendRequestSerializer
  include JSONAPI::Serializer
  attributes :requestor_id, :receiver_id, :status, :requestor_name, :receiver_name

  attribute :requestor_name do |friend_request|
    requestor = User.find_by(id: friend_request[:requestor_id])
    requestor.name
  end

  attribute :receiver_name do |friend_request|
    receiver = User.find_by(id: friend_request[:receiver_id])
    receiver.name
  end
end
