class FriendRequest < ApplicationRecord

    before_destroy :cancel_notifications
    
    belongs_to :sender, class_name: "User"
    belongs_to :receiver, class_name: "User"
    has_one :notification, as: :notifiable

    def cancel_notifications
        Notification.where(notifiable: self).destroy_all
    end
end
