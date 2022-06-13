class FriendRequestsController < ApplicationController
    before_action :authenticate_user!
    before_action :set_user

    def create
        @request = current_user.sent_requests.create(receiver: @user)
        @notification = @user.notifications.create(notifiable: @request)
        respond_to do |format|
            format.turbo_stream { flash.now[:notice] = "Friend request sent." }
        end
    end

    def destroy
        helpers.find_request(@user).destroy
        respond_to do |format|
            format.turbo_stream { flash.now[:notice] = "Friend request canceled." }
        end
    end

    private
    def set_user
        @user = User.find(params[:user_id])
    end

end