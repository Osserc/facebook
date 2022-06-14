module ApplicationHelper

    def same_user?(user)
        user == current_user
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

    def follows?(user)
        user.followers.include?(current_user)
    end

    def followed?(user)
        user.follows.include?(current_user)
    end

    def blocked?(user)
        user.blockers.include?(current_user)
    end

    def blocked_by?(user)
        user.blockeds.include?(current_user)
    end

    def find_request(user)
        user.requests.select { | request | request.sender == current_user || request.receiver == current_user }.first
    end

    def find_friendship(user)
        user.friendships.select { | friendship | friendship.friend_one == current_user || friendship.friend_two == current_user }.first
    end

    def find_blocking(user)
        user.blocked_by.find_by(blocker: current_user)
    end

    def find_following(user)
        user.followed_people.find_by(follow: current_user)
    end

    def find_follower(user)
        user.following_people.find_by(follower: current_user)
    end

    def find_following_both(user)
        user.followed_people.find_by(follow: current_user) + user.following_people.find_by(follower: current_user)
    end

    def text_post?
        params[:type] == "Text"
    end

    def image_post?
        params[:type] == "Image"
    end

    def liked?(object)
        object.likes.where(user: current_user).any?
    end

    def find_like(type, id)
        current_user.likes.where(likeable_type: type, likeable_id: id).first
    end

    def compose_notification_message(notification)
        issuer = link_to("#{notification.issuer.name}", user_path(notification.issuer))
        type, intermission = return_type_and_intermission(notification)
        return issuer, intermission, type
    end

    def return_type_and_intermission(notification)
        case notification.notifiable_type
        when "Post"
            return link_to("post", user_post_path(notification.issuer, notification.notifiable)), " published a new "
        when "FriendRequest"
            if notification.retracted
                return "friend request", " withdrew their "
            else
                return "friend request", " sent a "
            end
        when "Friendship"
            if notification.retracted
                return "friend", " is no longer your "
            else
                return "friend", " is now your "
            end
        when "Blocking"
            if notification.retracted
                return "", " blocked you"
            else
                return "", " unblocked you"
            end
        when "Comment"
            return "comment", " left you a "
        when "Like"
            return "#{notification.notifiable.likeable_type.downcase}", " liked your "
        when "Following"
            if notification.retracted
                return "", " is not following you"
            else
                return "", " is no longer following you"
            end
        end
    end

end