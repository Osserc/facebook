class Blocking < ApplicationRecord

    before_create :cancel_notification_retracted
    before_destroy :cancel_notification_advanced

    belongs_to :blocker, class_name: "User"
    belongs_to :blocked, class_name: "User"
    has_one :notification, as: :notifiable

    def cancel_notification_retracted
        Notification.where(notifiable_type: self.model_name.human).where(issuer: self.blocker).where(receiver: self.blocked).where(retracted: true).destroy_all
    end

    def cancel_notification_advanced
        Notification.where(notifiable_type: self.model_name.human).where(issuer: self.blocker).where(receiver: self.blocked).where(retracted: false).destroy_all
    end
end
