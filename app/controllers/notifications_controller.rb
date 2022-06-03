class NotificationsController < ApplicationController
    before_action :authenticate_user!

    def index
        @notifications = current_user.notifications
    end

    def show
    end

end