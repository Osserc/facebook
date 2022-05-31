class CommentsController < ApplicationController
    before_action :authenticate_user!

    def new
        @comment = current_user.comments.create
    end

    def edit
        @comment = current_user.comments.find(params[:id])
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
        @comment = current_user.comments.find(params[:id])
        respond_to do |format|
            if @comment.update(comment_params)
                format.turbo_stream { flash.now[:notice] = "Comment updated." }
                format.json { render :show, status: :ok, location: @post }
            else
                format.html { render :edit, status: :unprocessable_entity }
                format.json { render json: @post.errors, status: :unprocessable_entity }
            end
        end
    end

    def destroy
        current_user.comments.find(params[:comment_id]).destroy
        flash[:notice] = "Post succesfully deleted."
        respond_to do |format|
            format.turbo_stream
        end
    end

    private
    def comment_params
        params.require(:comment).permit(:commentable_type, :commentable_id, :body)
    end

end