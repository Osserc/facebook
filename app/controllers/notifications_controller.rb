class NotificationsController < ApplicationController
    before_action :authenticate_user!
    before_action :set_notifications, only: %i[ index show ]
    before_action :set_notification, only: %i[ read_notification ]

    def index
    end

    def show
    end

    def read_notification
        @notification[:read] = true
        respond_to do |format|
            format.turbo_stream
        end
    end    

    private
    def set_notifications
        @notifications = current_user.notifications
    end

    def set_notification
        @notification = Notification.find(params[:id])
    end

end