class FollowingsController < ApplicationController
    before_action :authenticate_user!
    before_action :set_user

    def create
        current_user.followed_people.create(follow: @user)
    end

    def destroy
        helpers.find_following(@user).destroy if helpers.blocked?(@user)
    end

    private
    def set_user
        @user = User.find(params[:user_id])
    end

end