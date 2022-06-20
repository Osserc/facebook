class Friendship < ApplicationRecord

    before_create :cancel_notification_retracted
    before_destroy :cancel_notification_advanced

    belongs_to :friend_one, class_name: "User"
    belongs_to :friend_two, class_name: "User"
    has_one :notification, as: :notifiable

    def cancel_notification_retracted
        Notification.where(notifiable_type: self.model_name.human).where(issuer: [self.friend_one, self.friend_two]).where(receiver: [self.friend_one, self.friend_two]).where(retracted: true).destroy_all
    end

    def cancel_notification_advanced
        Notification.where(notifiable_type: self.model_name.human).where(issuer: [self.friend_one, self.friend_two]).where(receiver: [self.friend_one, self.friend_two]).where(retracted: false).destroy_all
    end
end