class FriendshipsController < ApplicationController

    def create
        current_user.initiated_friendships.create(friend_two: User.find(params[:sender_id])) if check_received_request(User.find(params[:sender_id]))
        User.find(params[:sender_id]).sent_requests.find_by(receiver: current_user).destroy
    end

    def destroy
        find_friendship(User.find(params[:friend_id])).destroy
    end

    private
    def check_friendship
        current_user.friends.include?(User.find(params[:user_id]))
    end

    def find_friendship(user)
        user.friendships.select { | single | single.friend_one == current_user || single.friend_two == current_user }.first.id
    end

    def check_friend_position
        return true if current_user.befriendeds.include?(User.find(params[:friend_id]))
        return false if current_user.befriended_bys.include?(User.find(params[:friend_id]))
    end

end