class FriendRequestsController < ApplicationController
    before_action :authenticate_user!
    before_action :set_user, only: %i[ create destroy ]

    def create
        @request = current_user.sent_requests.create(receiver: @user)
    end

    def destroy
        current_user.sent_requests.find_by(receiver: @user).destroy
    end

    private
    def set_user
        @user = User.find(params[:requestee_id])
    end

    def check_request
        
    end

end