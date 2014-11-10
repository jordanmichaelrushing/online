class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_action :authenticate_user!

  USER_CHANNEL_KEY = 'user_channel_key'

  def after_sign_in_path_for(resource)
    if resource.is_a? User
      set_user_channel_cookie
    end
    super
  end

  def after_sign_out_path_for(resource)
    if resource.is_a? User
      clear_user_channel_cookie
    end
    super
  end

 private

 def set_user_channel_cookie
    key = current_user.channel_key
    WebsocketRails[key].make_private
    cookies[USER_CHANNEL_KEY] = {:value => key,
                                   :expires => 30.days.from_now }
  end

  def clear_user_channel_cookie
    cookies.delete USER_CHANNEL_KEY
  end
end
