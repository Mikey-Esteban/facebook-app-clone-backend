class Api::V1::PostsController < ApplicationController
  before_action :authenticate_user!

  def index
    posts = Post.all(order: :created_asc)

    render json: PostSerializer.new(posts).serializable_hash.to_json
  end

  def show
    post = Post.find_by(id: params[:id])

    render json: PostSerializer.new(post).serializable_hash.to_json
  end

  def create
    user = User.find_by(id: params[:post][:user_id])
    puts "User is: #{user.name}"
    post = user.posts.build(post_params)

    if post.save
      render json: PostSerializer.new(post).serializable_hash.to_json
    else
      render json: { error: post.errors.messages }, status: 422
    end
  end

  private

  def post_params
    params.require(:post).permit(:text, :user_id)
  end

end
