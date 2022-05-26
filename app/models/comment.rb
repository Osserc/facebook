class Comment < ApplicationRecord
    belongs_to :commentable, polymorphic: true
    belongs_to :author, class_name: "User", foreign_key: "author_id"
    has_many :comments, as: :commentable
    has_many :likes, as: :likeable

    validates :body, presence: true
end
