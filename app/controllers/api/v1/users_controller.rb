class Api::V1::UsersController < ApplicationController
  before_action :authenticate_user!, except:  :google_oauth2

  def google_oauth2
    puts 'GOOGLE OAUTH2 ROUTE HIT'
    puts params
    url = "https://www.googleapis.com/oauth2/v3/tokeninfo?id_token=#{params["id_token"]}"
    puts url
    response = RestClient.get(url)
    obj = JSON.parse(response)
    puts "obj #{obj}"
    @user = User.create_user_for_google(response.parsed_response)
    tokens = @user.create_new_auth_token
    @user.save
    render json:@user
  end

  def index
    users = User.all

    render json: UserSerializer.new(users, options).serializable_hash.to_json
  end

  def show
    user = User.find_by(id: params[:id])

    render json: UserSerializer.new(user, options).serializable_hash.to_json
  end

  def posts
    user = User.find_by(id: params[:id])
    posts = user.posts.order(created_at: :desc)

    render json: PostSerializer.new(posts).serializable_hash.to_json
  end

  private

  def options
    @options ||= { include: %i[sent_friend_requests] }
  end


end
