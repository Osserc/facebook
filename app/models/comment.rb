class Comment < ApplicationRecord
    belongs_to :commentable, polymorphic: true
    belongs_to :author, class_name: "User", foreign_key: "author_id"
    has_many :comments, as: :commentable

    validates :body, presence: true
end
