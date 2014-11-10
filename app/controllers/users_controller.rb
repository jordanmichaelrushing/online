class UsersController < ApplicationController

  def online
    @online_users = User.online
    @online_user_count = User.online_count
  end

end