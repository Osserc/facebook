class CommentsController < ApplicationController
    before_action :authenticate_user!
    before_action :set_root, only: %i[ new edit ]
    before_action :set_comment, only: %i[ show update more less ]

    def new
        @comment = current_user.comments.build
    end

    def edit
        @comment = current_user.comments.find(params[:id])
    end

    def show
    end

    def create
        @comment = current_user.comments.build(comment_params)
        respond_to do |format|
            if @comment.save
                @comment.commentable.author.notifications.create(notifiable: @comment, issuer: current_user)
                format.turbo_stream { flash.now[:notice] = "Comment succesfully saved." }
            else
                format.turbo_stream
            end
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
        @comment = current_user.comments.find(params[:comment_id])
        Notification.where(notifiable: @comment).destroy_all
        @parent = @comment.commentable
        @comment.destroy
        respond_to do |format|
            format.turbo_stream { flash.now[:notice] = "Comment succesfully deleted." }
        end
    end

    def more
        respond_to do |format|
            format.turbo_stream
        end
    end

    def less
        respond_to do |format|
            format.turbo_stream
        end
    end

    private
    def comment_params
        params.require(:comment).permit(:commentable_type, :commentable_id, :root_id, :body)
    end

    def set_comment
        @comment = Comment.find(params[:id])
    end

    def set_root
        @root = Post.find(params[:root_id])
    end

end