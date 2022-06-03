class BlockingsController < ApplicationController
    before_action :authenticate_user!
    before_action :set_user

    def create
        @block = current_user.blocked_people.create(blocked: @user)
        helpers.find_friendship(@user).destroy if helpers.friends?(@user)
        helpers.find_request(@user).destroy if !helpers.find_request(@user).nil?
        @user.notifications.create(notifiable: @block, issuer: current_user)
    end

    def destroy
        helpers.find_blocking(@user).destroy if helpers.blocked?(@user)
        @user.notifications.create(notifiable_type: "Blocking", issuer: current_user, retracted: true)
    end

    private
    def set_user
        @user = User.find(params[:user_id])
    end

end