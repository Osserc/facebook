class CommentsController < ApplicationController
    before_action :authenticate_user!

    def new
        @comment = current_user.comments.create
    end

    def edit
    end

    def create
        @comment = current_user.comments.create!(comment_params)
        if @comment.save
            flash[:notice] = "Post succesfully saved."
        else
            render :new, status: :unprocessable_entity
        end
    end

    def update
    end

    def destroy
        Comment.find(params[:comment_id]).destroy
        flash[:notice] = "Post succesfully deleted."
    end

    private
    def comment_params
        params.require(:comment).permit(:commentable_type, :commentable_id, :body)
    end

end