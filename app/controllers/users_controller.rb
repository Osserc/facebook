class UsersController < ApplicationController
    before_action :authenticate_user!

    def index
        @users = User.all
        @recommended_friends = current_user.recommend_friends
        @recommended_follows = current_user.recommend_follows
    end

    def show
        @user = User.find(params[:id])
    end

end