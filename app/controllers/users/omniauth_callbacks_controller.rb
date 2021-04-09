require 'rest-client'

class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController

  def google_oauth2
    puts 'GOOGLE OAUTH2 ROUTE HIT'
    url = "https://www.googleapis.com/oauth2/v3/tokeninfo?id_token=#{params["id_token"]}"
    response = RestClient.get(url)
    obj = JSON.parse(response)
    puts "obj #{obj}"
    @user = User.create_user_for_google(response.parsed_response)
    tokens = @user.create_new_auth_token
    @user.save
    render json:@user
  end

end
