class Api::V1::UsersController < ApplicationController

  def create
    puts "PARAMS: #{params}"
    user = User.find_by(email: params[:user][:email])
    puts "hiyoooo im in user#create"
    puts "user: #{user.name}, #{user.password}, #{user.email}"

    render json: UserSerializer.new(user).serializable_hash.to_json
  end



end
