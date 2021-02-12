class Api::V1::UsersController < ApplicationController
  before_action :authenticate_user!

  def index
    users = User.all

    render json: UserSerializer.new(users).serializable_hash.to_json
  end

end
