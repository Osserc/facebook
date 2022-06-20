class FollowingsController < ApplicationController
    before_action :authenticate_user!
    before_action :set_user

    def index
        @followers = @user.followers
        @follows = @user.follows
    end

    def create
        @follow = current_user.followed_people.create(follow: @user)
        @user.notifications.create(notifiable: @follow, issuer: current_user)
        respond_to do |format|
            format.turbo_stream { flash.now[:notice] = "Followed monke." }
        end
    end

    def destroy
        helpers.find_follower(@user).destroy
        @user.notifications.create(notifiable_type: "Following", issuer: current_user, retracted: true)
        respond_to do |format|
            format.turbo_stream { flash.now[:notice] = "Unfollowed monke." }
        end
    end

    private
    def set_user
        @user = User.find(params[:user_id])
    end

end