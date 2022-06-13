class FriendshipsController < ApplicationController
    before_action :authenticate_user!
    before_action :set_user

    def create
        @friendship = current_user.initiated_friendships.create(friend_two: @user) if helpers.requested?(@user)
        helpers.find_request(@user).destroy
        @user.notifications.create(notifiable: @friendship, issuer: current_user)
        respond_to do |format|
            format.turbo_stream { flash.now[:notice] = "Friend added." }
        end
    end

    def destroy
        helpers.find_friendship(@user).destroy if helpers.friends?(@user)
        @user.notifications.create(notifiable_type: "Friendship", issuer: current_user, retracted: true)
        respond_to do |format|
            format.turbo_stream { flash.now[:notice] = "Friend removed." }
        end
    end

    private
    def set_user
        @user = User.find(params[:user_id])
    end

end