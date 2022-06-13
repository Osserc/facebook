class NotificationsController < ApplicationController
    before_action :authenticate_user!
    before_action :set_unread_notifications, :set_read_notifications, only: %i[ index show ]
    before_action :set_notification, only: %i[ mark_read ]

    def index
    end

    def show
    end

    def update
    end

    def mark_read
        @notification.read = true
        @notification.save
        respond_to do |format|
            format.turbo_stream
        end
    end    

    private
    def set_unread_notifications
        @unread_notifications = current_user.notifications.where(read: false).sort_by(&:created_at).reverse
    end

    def set_read_notifications
        @read_notifications = current_user.notifications.where(read: true).sort_by(&:created_at).reverse
    end

    def set_notification
        @notification = Notification.find(params[:id])
    end

end