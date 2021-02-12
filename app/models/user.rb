class User < ApplicationRecord
  include Devise::JWT::RevocationStrategies::JTIMatcher

  devise :database_authenticatable, :registerable,
         :jwt_authenticatable, jwt_revocation_strategy: self

  has_many :sent_friend_requests,
    foreign_key: :requestor_id,
    class_name: :FriendRequest

  has_many :received_friend_requests,
    foreign_key: :receiver_id,
    class_name: :FriendRequest
end
