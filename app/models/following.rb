class Following < ApplicationRecord
    belongs_to :follower, class_name: "User"
    belongs_to :follow, class_name: "User"
    has_one :notification, as: :notifiable
end
