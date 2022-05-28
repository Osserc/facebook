module ApplicationHelper

    def same_user?(user)
        current_user == user
    end

    def friends?(user)
        user.friends.include?(current_user)
    end

    def requested?(user)
        user.sent_requests.exists?(receiver: current_user)
    end

    def sent?(user)
        user.received_requests.exists?(sender: current_user)
    end

    def find_request(user)
        user.requests.select { | request | request.sender == current_user || request.receiver == current_user }.first
    end

    def find_friendship(user)
        user.friendships.select { | friendship | friendship.friend_one == current_user || friendship.friend_two == current_user }.first
    end


end