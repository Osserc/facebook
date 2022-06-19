class Like < ApplicationRecord
    before_destroy :cancel_notifications

    belongs_to :likeable, polymorphic: true
    has_one :notification, as: :notifiable
    belongs_to :user

    def cancel_notifications
        Notification.where(notifiable: self).destroy_all
    end
end
