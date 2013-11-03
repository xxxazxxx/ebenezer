class ApplicationController < ActionController::API
  include ActionController::MimeResponds

  before_filter :authenticate_user_from_token!
  before_filter :authenticate_user!, :except => [:login]

  def resource_name
    :user
  end

  def resource
    @resource ||= User.new
  end

  def devise_mapping
    @devise_mapping ||= Devise.mappings[:user]
  end

  private
    
  def authenticate_user_from_token!
    user_token    = request.headers["token"]
    user          = user_token && User.find_by_authentication_token(user_token)
    authenticated = user && user.email == request.headers["email"]
 
    if authenticated
      # Notice we are passing store false, so the user is not
      # actually stored in the session and a token is needed
      # for every request. If you want the token to work as a
      # sign in token, you can simply remove store: false.
      sign_in user, store: false
    end
  end

end
