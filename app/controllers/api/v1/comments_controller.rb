class Api::V1::CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :find_post, except: :destroy

  def create
    comment = @post.comments.new(comment_params)

    if comment.save
      render json: PostSerializer.new(@post).serializable_hash.to_json
    else
      render json: { error: comment.errors.messages }, status: 422
    end
  end

  private

  def comment_params
    params.require(:comment).permit(:text, :user_id, :post_id, :commenter)
  end

  def find_post
    @post = Post.find_by(id: params[:comment][:post_id])
  end

end
