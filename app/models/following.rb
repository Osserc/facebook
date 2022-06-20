class Following < ApplicationRecord

    before_create :cancel_notification_retracted
    before_destroy :cancel_notification_advanced
    
    belongs_to :follower, class_name: "User"
    belongs_to :follow, class_name: "User"
    has_one :notification, as: :notifiable

    def cancel_notification_retracted
        Notification.where(notifiable_type: self.model_name.human).where(issuer: self.follower).where(receiver: self.follow).where(retracted: true).destroy_all
    end

    def cancel_notification_advanced
        Notification.where(notifiable_type: self.model_name.human).where(issuer: self.follower).where(receiver: self.follow).where(retracted: false).destroy_all
    end
end