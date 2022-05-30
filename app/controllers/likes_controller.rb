class LikesController < ApplicationController
    before_action :authenticate_user!

    def create
        current_user.likes.create(like_params)
    end

    def destroy
        helpers.find_like(params[:likeable_type], params[:likeable_id]).destroy
    end

    private
    def like_params
        params.permit(:likeable_type, :likeable_id)
    end

end