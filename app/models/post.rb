class Post < ApplicationRecord
    validates_associated :postable

    before_destroy :cancel_notifications

    delegated_type :postable, types: %w[ TextPost ImagePost ], dependent: :destroy
    belongs_to :author, class_name: "User", foreign_key: "author_id"
    has_many :comments, as: :commentable, dependent: :destroy
    has_many :likes, as: :likeable, dependent: :destroy
    has_one :notification, as: :notifiable, dependent: :destroy

    def cancel_notifications
        Notification.where(notifiable: self).destroy_all
    end
end