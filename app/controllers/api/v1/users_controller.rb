class Api::V1::UsersController < ApplicationController
  before_action :authenticate_user!

  def index
    users = User.all

    render json: UserSerializer.new(users, options).serializable_hash.to_json
  end

  def show
    user = User.find_by(id: params[:id])

    render json: UserSerializer.new(user, options).serializable_hash.to_json
  end


  private

  def options
    @options ||= { include: %i[sent_friend_requests] }
  end


end
