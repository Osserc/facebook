class ProfilesController < ApplicationController
    before_action :authenticate_user!
    before_action :set_user_and_profile

    def edit
    end

    def update
        if @profile.update!(profile_params)
            redirect_to user_path(@user)
        else
            render :edit, status: :unprocessable_entity
        end
    end

    private
    def set_user_and_profile
        @user = User.find(params[:user_id])
        @profile = @user.profile
    end

    def profile_params
        params.require(:profile).permit(:bio, :avatar)
    end

end