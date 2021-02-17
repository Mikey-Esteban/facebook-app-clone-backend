class Api::V1::FriendRequestsController < ApplicationController
  before_action :authenticate_user!

  def create
    friend_request = FriendRequest.new(friend_request_params)
    # create a notification for the receiver
    notification = send_notification_to_receiver(friend_request)

    if friend_request.save && notification.save
      render json: FriendRequestSerializer.new(friend_request).serializable_hash.to_json
    else
      render json: { error: [friend_request.errors.messages, notification.errors.messages] }, status: 422
    end
  end

  def update
    friend_request = FriendRequest.find_by(id: params[:id])

    if friend_request.update(friend_request_params)
      if friend_request.status == 'accepted'
        # add to friendships table
        add_friendships(friend_request)
        # create a notification to let receiver know friendship is added
        notification = send_friendship_notification_to_requestor(friend_request)
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

  def find_receiver(friend_request)
    receiver = User.find_by(id: friend_request.receiver_id)
    receiver
  end

  def find_requestor(friend_request)
    requestor = User.find_by(id: friend_request.requestor_id)
    requestor
  end

  def send_notification_to_receiver(friend_request)
    requestor = find_requestor(friend_request)
    receiver = find_receiver(friend_request)
    notification = receiver.notifications.new(text: "#{requestor.name} sent you a friend request!")
  end

  def send_friendship_notification_to_requestor(friend_request)
    requestor = find_requestor(friend_request)
    receiver = find_receiver(friend_request)
    notification = requestor.notifications.create(text: "#{receiver.name} added you back as a friend!")
  end

  def add_friendships(friend_request)
    requestor = find_requestor(friend_request)
    receiver = find_receiver(friend_request)
    receiver.friendships << requestor
    requestor.friendships << receiver
  end

end
