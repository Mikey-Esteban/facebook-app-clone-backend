class Api::V1::NotificationsController < ApplicationController

  def destroy
    notification = Notification.find_by(id: params[:id])

    if notification.destroy
      head :no_content
    else
      render json: { error: notification.errors.messages }, status: 422
    end
  end

end
