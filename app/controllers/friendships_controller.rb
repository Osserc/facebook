class FriendshipsController < ApplicationController
    before_action :authenticate_user!
    before_action :set_user

    def create
        current_user.initiated_friendships.create(friend_two: @user) if helpers.requested?(@user)
        @user.sent_requests.find_by(receiver: current_user).destroy
    end

    def destroy
        helpers.find_friendship(@user).destroy if helpers.friends?(@user)
    end

    private
    def set_user
        @user = User.find(params[:user_id])
    end

    def check_friendship
        current_user.friends.include?(User.find(params[:user_id]))
    end

end