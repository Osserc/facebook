class Comment < ApplicationRecord
    belongs_to :commentable, polymorphic: true
    belongs_to :author, class_name: "User", foreign_key: "author_id"
    belongs_to :root, class_name: "Post"
    has_many :comments, as: :commentable, dependent: :destroy
    has_many :likes, as: :likeable
    has_one :notification, as: :notifiable

    validates :body, presence: { message: "Say something!" }
end
