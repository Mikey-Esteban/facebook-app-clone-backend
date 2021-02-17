class Api::V1::NotificationsController < ApplicationController
  before_action :authenticate_user!

  def update
    notification = Notification.find_by(id: params[:id])

    if notification.update(notification_params)
      render json: { message: 'updated read status' }
    else
      render json: { error: notification.errors.messages }, status: 422
    end

  end

  def destroy
    notification = Notification.find_by(id: params[:id])

    if notification.destroy
      head :no_content
    else
      render json: { error: notification.errors.messages }, status: 422
    end
  end

  private

  def notification_params
    params.require(:notification).permit(:text, :read)
  end

end
