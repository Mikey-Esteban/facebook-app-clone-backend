class Api::V1::FriendRequestsController < ApplicationController
  before_action :authenticate_user!

  def create
    friend_request = FriendRequest.new(friend_request_params)
    # create a notification for the receiver
    requestor = User.find_by(id: friend_request.requestor_id)
    receiver = User.find_by(id: friend_request.receiver_id)
    notification = receiver.notifications.new(text: "#{requestor.name} sent you a friend request!")

    if friend_request.save && notification.save
      render json: FriendRequestSerializer.new(friend_request).serializable_hash.to_json
    else
      render json: { error: [friend_request.errors.messages, notification.errors.messages] }, status: 422
    end
  end

  def update
    friend_request = FriendRequest.find_by(id: params[:id])

    if friend_request.update(friend_request_params)
      # add to friendships table if status is accepted
      if friend_request.status = 'accepted'
        receiver = User.find_by(id: friend_request.receiver_id)
        requestor = User.find_by(id: friend_request.requestor_id)
        receiver.friendships << requestor
        requestor.friendships << receiver
      end
      render json: FriendRequestSerializer.new(friend_request).serializable_hash.to_json
    else
      render json: { error: friend_request.errors.messages }, status: 422
    end
  end

  def destroy
    friend_request = FriendRequest.find_by(id: params[:id])

    if friend_request.destroy
      head :no_content
    else
      render json: { error: friend_request.errors.messages }, status: 422
    end
  end

  private

  def friend_request_params
    params.require(:friend_request).permit(:id, :requestor_id, :receiver_id,
      :requestor_name, :receiver_name, :status)
  end

end
