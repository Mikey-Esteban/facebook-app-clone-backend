class Api::V1::FriendRequestsController < ApplicationController
  before_action :authenticate_user!
  before_action :find_requestor, :find_receiver, except: :destroy

  def create
    friend_request = FriendRequest.new(friend_request_params)

    if friend_request.save
      # create a notification for the receiver
      send_notification_to_receiver

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
        add_friendships
        # create a notification to let receiver know friendship is added
        send_friendship_notification_to_requestor
      end
      render json: FriendRequestSerializer.new(friend_request).serializable_hash.to_json
    else
      render json: { error: friend_request.errors.messages }, status: 422
    end
  end

  def destroy
    puts "IN RAILS DESTROY"
    friend_request = FriendRequest.find_by(id: params[:id])
    puts "FRIEND REQEUST #{friend_request}"

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

  def find_receiver
    @receiver = User.find_by(id: params[:friend_request][:receiver_id])
  end

  def find_requestor
    @requestor = User.find_by(id: params[:friend_request][:requestor_id])
  end

  def send_notification_to_receiver
    notification = @receiver.notifications.create(text: "#{@requestor.name} sent you a friend request!")
  end

  def send_friendship_notification_to_requestor
    notification = Notification.create(text: "#{@receiver.name} added you back as a friend!")
    @requestor.notifications << notification
  end

  def add_friendships
    puts "requestor #{@requestor.name}"
    puts "receiver: #{@receiver.name}"
    @requestor.friendships << @receiver
    @receiver.friendships << @requestor
  end

end
