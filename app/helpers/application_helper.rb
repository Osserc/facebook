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


# <% unless same_user?(user) || check_received_request(user) %>
#     <%= button_to "Send Friend request", friend_requests_path, params: { requestee_id: user.id } %>
# <% end %>
# <% if find_request(user) %>
#     <%= button_to "Cancel Friend request", friend_request_path(find_request(user).id), method: :delete, params: { requestee_id: user.id } %>
# <% end %>
# <% if check_received_request(user) %>
#     <%= button_to "Accept Friend request", friendships_path, params: { sender_id: user.id } %>
# <% end %>
# <% if friends?(user) %>
#     <%= button_to "Remove friend", friendship_path(find_friendship(user)), method: :delete, params: { friend_id: user.id } %>
# <% end %>