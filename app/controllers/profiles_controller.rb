class ProfilesController < ApplicationController
    before_action :authenticate_user!
    before_action :set_user_and_profile

    def edit
    end

    def update
    end

    private
    def set_user_and_profile
        @user = User.find(params[:user_id])
        @profile = @user.profile
    end

end