class Friendship < ApplicationRecord
    belongs_to :friend_one, class_name: "User"
    belongs_to :friend_two, class_name: "User"
end
