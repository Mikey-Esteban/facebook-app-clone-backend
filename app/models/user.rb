class User < ApplicationRecord
  include Devise::JWT::RevocationStrategies::JTIMatcher

  devise :database_authenticatable, :registerable,
         :jwt_authenticatable, jwt_revocation_strategy: self

  has_many :posts, dependent: :destroy

  has_many :notifications, dependent: :destroy

  has_many :sent_friend_requests,
    foreign_key: :requestor_id,
    class_name: :FriendRequest,
    dependent: :destroy

  has_many :received_friend_requests,
    foreign_key: :receiver_id,
    class_name: :FriendRequest,
    dependent: :destroy

  has_and_belongs_to_many :friendships,
     class_name: "User",
     join_table:  :friendships,
     foreign_key: :user_id,
     association_foreign_key: :friend_user_id,
     dependent: :destroy
end
