class Api::V1::FriendRequestsController < ApplicationController
  before_action :authenticate_user!

  def create
    puts "in friend requests create"
    puts "PARAMS #{params}"
    friend_request = FriendRequest.new(friend_request_params)

    if friend_request.save
      render json: FriendRequestSerializer.new(friend_request).serializable_hash.to_json
    else
      render json: { error: friend_request.errors.messages }, status: 422
    end
  end


  private

  def friend_request_params
    params.require(:friend_request).permit(:requestor_id, :receiver_id, :status)
  end

end
