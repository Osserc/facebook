class FriendRequestsController < ApplicationController
    before_action :authenticate_user!
    before_action :set_user, only: %i[ create destroy ]

    def create
        @request = current_user.sent_requests.create(receiver: @user)
        @notification = @user.notifications.create(notifiable: @request)
    end

    def destroy
        helpers.find_request(@user).destroy
    end

    private
    def set_user
        @user = User.find(params[:user_id])
    end

end