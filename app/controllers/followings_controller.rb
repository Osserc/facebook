class FollowingsController < ApplicationController
    before_action :authenticate_user!
    before_action :set_user

    def create
        current_user.followed_people.create(follow: @user)
    end

    def destroy
        helpers.find_follower(@user).destroy if helpers.find_follower(@user)
    end

    private
    def set_user
        @user = User.find(params[:user_id])
    end

end