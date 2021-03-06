class PostsController < ApplicationController
    before_action :authenticate_user!
    before_action :set_user, only: %i[ index show ]
    before_action :hide_timeline, :friends_timeline, :follows_timeline, only: %i[ index ]
    before_action :set_post, only: %i[ show edit update destroy ]
    before_action :exclude_blockeds, only: %i[ show ]

    def index
    end

    def show
    end

    def new
        @user = current_user
        type = params[:type].to_s + "Post"
        @post = current_user.posts.build postable: type.constantize.new
    end

    def edit
    end

    def create
        @post = Post.new postable: params[:post][:kind].constantize.new(post_params), author: current_user
        respond_to do |format|
            if @post.save
                current_user.followers.each do | follower |
                    follower.notifications.create(notifiable: @post, issuer: current_user)
                end
                flash[:notice] = "Post succesfully created."
                format.html { redirect_to user_post_path(current_user.id, @post.id) }
            else
                format.turbo_stream
                format.html { render :new, status: :unprocessable_entity }          
            end
        end
    end

    def update
        respond_to do |format|
            if @post.postable.update(post_params)
                format.turbo_stream { flash.now[:notice] = "Post updated." }
                format.json { render :show, status: :ok, location: @post }
            else
                format.turbo_stream
                format.html { render :edit, status: :unprocessable_entity }
                format.json { render json: @post.errors, status: :unprocessable_entity }
            end
        end
    end

    def destroy
        @post.destroy
        flash[:notice] = "Post succesfully deleted."
        redirect_to user_path(params[:user_id])
    end

    private
    def set_user
        @user = User.find(params[:user_id])
    end

    def set_post
        @post = Post.find(params[:id])
    end

    def friends_timeline
        friends_posts = Array.new
        @user.posts.each { | post | friends_posts  << post }
        @user.friends.each do | friend |
            friend.posts.each { | post | friends_posts  << post }
        end
        @timeline_friends = friends_posts.sort_by(&:created_at).reverse
    end

    def follows_timeline
        follows_posts = Array.new
        @user.follows.each do | follow |
            follow.posts.each { | post | follows_posts << post}
        end
        @timeline_follows = follows_posts.sort_by(&:created_at).reverse
    end

    def hide_timeline
        if !helpers.same_user?(@user)
        flash[:notice] = "No peeking at someone else's timeline."
        redirect_to root_path
        end
    end

    def exclude_blockeds
        if helpers.blocked_by?(@user)
            flash[:notice] = "You are blocked."
            redirect_to root_path
        end
    end

    def post_params
        params.require(:post).permit(:user_id, :id, :title, :body, :image)
    end

end