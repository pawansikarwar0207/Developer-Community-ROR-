class PostsController < ApplicationController
  before_action :set_post, only: %i[edit show update destroy]
  
  def index
    if params[:q].present?
      @posts = @query.result(distinct: true)
    else
      @posts = current_user.posts.includes(:user, :comments, :likes, image_attachment: :blob).order(created_at: :desc)
    end
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

end
