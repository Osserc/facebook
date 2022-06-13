class FollowingsController < ApplicationController
    before_action :authenticate_user!
    before_action :set_user

    def create
        @follow = current_user.followed_people.create(follow: @user)
        helpers.clear_follow_relations(user)
        @user.notifications.create(notifiable: @follow, issuer: current_user)
        respond_to do |format|
            format.turbo_stream { flash.now[:notice] = "Followed monke." }
        end
    end

    def destroy
        helpers.find_follower(@user).destroy if helpers.find_follower(@user)
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