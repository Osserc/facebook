class BlockingsController < ApplicationController
    before_action :authenticate_user!
    before_action :set_user

    def create
        current_user.blocked_people.create(blocked: @user)
        helpers.find_friendship(@user).destroy if helpers.friends?(@user)
        helpers.find_request(@user).destroy if !helpers.find_request(@user).nil?
        # helpers.find_following_both(@user).destroy_all if helpers.follows?(@user) || helpers.followed?(@user)
    end

    def destroy
        helpers.find_blocking(@user).destroy if helpers.blocked?(@user)
    end

    private
    def set_user
        @user = User.find(params[:user_id])
    end

end