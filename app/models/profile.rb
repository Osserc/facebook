class Profile < ApplicationRecord
    belongs_to :user
    has_one_attached :avatar

    validates :avatar, size: { less_than: 10.megabytes, message: "Your file exceeds 10 megabytes." }, content_type: [:png, :jpg, :jpeg]
end
