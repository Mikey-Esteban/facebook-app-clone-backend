class Api::V1::LikesController < ApplicationController
  before_action :authenticate_user!, :find_post

  def create
    @post.likes.create(user_id: current_user.id)

    render json: { message: "#{current_user.name} liked this post" }
  end

  private

  def find_post
    @post = Post.find(params[:post_id])
  end

end
