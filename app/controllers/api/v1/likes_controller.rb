class Api::V1::LikesController < ApplicationController
  before_action :authenticate_user!, :find_post
  before_action :find_like, only: :destroy

  def create
    like = @post.likes.build(user_id: current_user.id)

    if like.save
      render json: LikeSerializer.new(like).serializable_hash.to_json
    else
      render json: { errors: like.errors.messages }, status: 422
    end
  end

  def destroy
    if @like.destroy
      render json: { message: "#{current_user.name} unliked this post" }
    else
      render json: { errors: @post.likes.errors.messages }, status: 422
    end
  end

  private

  def find_post
    @post = Post.find(params[:post_id])
  end

  def find_like
    @like = @post.likes.find(params[:id])
  end

end
