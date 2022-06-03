class PostsController < ApplicationController
    before_action :authenticate_user!
    before_action :set_user, only: %i[ index ]
    before_action :set_post, only: %i[ show edit update destroy ]

    def index
        @posts = @user.posts
    end

    def show
    end

    def new
        @post = current_user.posts.create
    end

    def edit
    end

    def create
        @post = Post.create! postable: TextPost.new(post_params), author: current_user
        current_user.followers.each do | follower |
            follower.notifications.create(notifiable: @post, issuer: current_user)
        end
        if @post.save
            flash[:notice] = "Post succesfully saved."
            redirect_to user_post_path(current_user.id, @post.id)
        else
            render :new, status: :unprocessable_entity
        end
    end

    def update
        respond_to do |format|
            if @post.postable.update(post_params)
                format.turbo_stream { flash.now[:notice] = "Post updated." }
                format.json { render :show, status: :ok, location: @post }
            else
                format.html { render :edit, status: :unprocessable_entity }
                format.json { render json: @post.errors, status: :unprocessable_entity }
            end
        end
    end

    def destroy
        @post.destroy
        redirect_to user_path(params[:user_id]), flash[:notice] = "Post succesfully deleted."
    end

    private
    def set_user
        @user = User.find(params[:user_id])
    end

    def set_post
        @post = Post.find(params[:id])
    end

    def post_params
        params.require(:post).permit(:user_id, :id, :title, :body)
    end

end