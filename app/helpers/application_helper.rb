module ApplicationHelper

    def same_user?(user)
        user == current_user
    end

    def check_request(receiver)
        current_user.sent_requests.find_by(receiver: receiver)
    end

end
