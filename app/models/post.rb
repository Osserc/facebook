class Post < ApplicationRecord
    delegated_type :postable, types: %w[ TextPost ]
    belongs_to :author, class_name: "User", foreign_key: "author_id"
end
