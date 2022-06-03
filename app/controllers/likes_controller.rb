class LikesController < ApplicationController
    before_action :authenticate_user!
    before_action :set_turbo_object

    def create
        @like = current_user.likes.create(like_params)
        @like.likeable.author.notifications.create(notifiable: @like, issuer: current_user)
        respond_to do |format|
            format.turbo_stream { flash.now[:notice] = "Liked post." }
        end
    end

    def destroy
        helpers.find_like(params[:likeable_type], params[:likeable_id]).destroy
        respond_to do |format|
            format.turbo_stream { flash.now[:notice] = "Unliked post." }
        end
    end

    private
    def like_params
        params.permit(:likeable_type, :likeable_id)
    end

    def set_turbo_object
        @object = "like_" + params[:likeable_type].downcase + "_" + params[:likeable_id]
        @type = params[:likeable_type]
        @id = params[:likeable_id]
    end

end