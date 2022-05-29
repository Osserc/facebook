class FriendshipsController < ApplicationController
    before_action :authenticate_user!
    before_action :set_user

    def create
        current_user.initiated_friendships.create(friend_two: @user) if helpers.requested?(@user)
        helpers.find_request(@user).destroy
    end

    def destroy
        helpers.find_friendship(@user).destroy if helpers.friends?(@user)
    end

    private
    def set_user
        @user = User.find(params[:user_id])
    end

end