class Following < ApplicationRecord

    before_destroy :cancel_notifications
    
    belongs_to :follower, class_name: "User"
    belongs_to :follow, class_name: "User"
    has_one :notification, as: :notifiable

    def cancel_notifications
        Notification.where(notifiable: self).destroy_all
    end
end
