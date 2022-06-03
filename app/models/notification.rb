class Notification < ApplicationRecord
    delegated_type :notifiable, types: %w[ Post FriendRequest Friendship Blocking Comment Like Following ], optional: true
    belongs_to :receiver, class_name: "User"
    belongs_to :issuer, class_name: "User"
end