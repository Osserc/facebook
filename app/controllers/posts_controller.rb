class PostsController < ApplicationController
    before_action :set_user
    before_action :authenticate_user!
    before_action :set_post, only: %i[ show edit update destroy ]

    def index
        @posts = @user.posts
    end

    def show
    end

    def new
        @post = @user.posts.create
    end

    def edit
    end

    def create
        @post = Post.create postable: TextPost.new(title: params[:title], body: params[:body]), author: @user
        if @post.save
            redirect_to user_post_path(@user.id, @post.id), flash[:notice] = "Post succesfully saved."
        else
            render :new, status: :unprocessable_entity
        end
    end

    def update
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
        params.permit(:user_id, :id, :title, :body)
    end

end