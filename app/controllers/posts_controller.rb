class PostsController < ApplicationController
  before_action :set_post, only: %i[edit show update destroy]
  
  def index
  @posts = current_user.posts.includes(:user, :comments, :notifications, :likes, image_attachment: :blob).order(created_at: :desc)
  end

  def new
    @post = Post.new
  end

  def create
    @post = Post.create(post_params)
    if @post.save
      redirect_to root_path
    end
  end

  def show
    @user = @post.user
    @comments = @post.comments.includes(:user).order(created_at: :desc)
    mark_notifications_as_read
  end

  def edit
  end

  def update
    if @post.update(post_params)
      redirect_to root_path
    else
      render :edit
    end
  end

  def destroy
    if @post.destroy
      redirect_to root_path
    end
  end


  private

  def set_post
    @post = Post.find(params[:id])
  end

  def post_params
    params.require(:post).permit(:title, :description, :user_id, :image)
  end

  def mark_notifications_as_read
    if current_user
      notifications_to_mark_as_read = @post.notifications_as_post.where(recipient: current_user)
      notifications_to_mark_as_read.update_all(read_at: Time.zone.now)
    end
  end

end
