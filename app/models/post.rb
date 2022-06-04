class Post < ApplicationRecord
    delegated_type :postable, types: %w[ TextPost ImagePost ]
    belongs_to :author, class_name: "User", foreign_key: "author_id"
    has_many :comments, as: :commentable
    has_many :likes, as: :likeable
    has_one :notification, as: :notifiable
end
