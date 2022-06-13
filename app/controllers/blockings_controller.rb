class BlockingsController < ApplicationController
    before_action :authenticate_user!
    before_action :set_user

    def create
        @block = current_user.blocked_people.create(blocked: @user)
        helpers.find_friendship(@user).destroy if helpers.friends?(@user)
        helpers.find_request(@user).destroy if !helpers.find_request(@user).nil?
        clear_follow_relations(@user)
        @user.notifications.create(notifiable: @block, issuer: current_user)
        respond_to do |format|
            format.turbo_stream { flash.now[:notice] = "Blocked monke." }
        end
    end

    def destroy
        helpers.find_blocking(@user).destroy if helpers.blocked?(@user)
        @user.notifications.create(notifiable_type: "Blocking", issuer: current_user, retracted: true)
        respond_to do |format|
            format.turbo_stream { flash.now[:notice] = "Unblocked monke." }
        end
    end

    private
    def set_user
        @user = User.find(params[:user_id])
    end

    def clear_follow_relations(user)
        Following.where(follower: user, follow: current_user).or(Following.where(follower: current_user, follow: user)).destroy_all
    end

end