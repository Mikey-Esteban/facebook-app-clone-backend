class User < ApplicationRecord
  include Devise::JWT::RevocationStrategies::JTIMatcher

  devise :database_authenticatable, :registerable,
         :omniauthable, :jwt_authenticatable, jwt_revocation_strategy: self,
         :omniauth_providers => [:google_oauth2]

   def self.create_user_for_google(data)
     puts 'IN USER create_user_for_google'
     where(uid: data["email"]).first_or_initialize.tap do |user|
       user.provider="google_oauth2"
       user.uid=data["email"]
       user.email=data["email"]
       user.password=Devise.friendly_token[0,20]
       # user.password_confirmation=user.password
       user.save!
     end
   end

  has_one :profile, dependent: :destroy
  has_many :posts, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :likes, dependent: :destroy

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
