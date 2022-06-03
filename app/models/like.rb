class Like < ApplicationRecord
    belongs_to :likeable, polymorphic: true
    has_one :notification, as: :notifiable

    belongs_to :user
end
