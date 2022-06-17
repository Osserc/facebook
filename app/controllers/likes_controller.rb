class LikesController < ApplicationController
    before_action :authenticate_user!
    before_action :set_object

    def create
        @like = current_user.likes.create(like_params)
        @like.likeable.author.notifications.create(notifiable: @like, issuer: current_user)
        respond_to do |format|
            format.turbo_stream { flash.now[:notice] = "Liked post." }
        end
    end

    def destroy
        like = helpers.find_like(params[:likeable_type], params[:likeable_id]).dstroy
        like.notification.destroy
        like.destroy

        respond_to do |format|
            format.turbo_stream { flash.now[:notice] = "Unliked post." }
        end
    end

    def likers
        @likers = @object.likes.map { | like | like.user }
    end

    private
    def like_params
        params.permit(:likeable_type, :likeable_id)
    end

    def set_object
        @object = params[:likeable_type].constantize.find(params[:likeable_id])
    end

end