class FriendshipsController < ApplicationController

    def create
        current_user.initiated_friendships.create(friend_two: User.find(params[:sender_id])) if check_request
        User.find(params[:sender_id]).sent_requests.find_by(receiver: current_user]).destroy
    end

    def destroy
        if check_friend_position
            current_user.initiated_friendships.find_by(friend_two: User.find(params[:user_id])).destroy
        else
            current_user.received_friendships.find_by(friend_two: User.find(params[:user_id])).destroy
        end
    end

    private
    def check_request
        current_user.received_requests.find_by(sender: params[:sender_id])
    end

    def check_friendship
        current_user.friends.include?(User.find(params[:user_id]))
    end

    def check_friend_position
        return true if current_user.befriendeds.include?(User.find(params[:user_id]))
        return false if current_user.befriended_bys.include?(User.find(params[:user_id]))
    end

end