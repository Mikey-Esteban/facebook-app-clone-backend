class Api::V1::FriendRequestsController < ApplicationController
  before_action :authenticate_user!

  def create
    friend_request = FriendRequest.new(friend_request_params)

    if friend_request.save
      render json: FriendRequestSerializer.new(friend_request).serializable_hash.to_json
    else
      render json: { error: friend_request.errors.messages }, status: 422
    end
  end

  def update
    puts "PARAMS: #{params}"
    friend_request = FriendRequest.find_by(id: params[:friend_request][:id])
    puts "FR: #{friend_request}"

    if friend_request.update(friend_request_params)
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
