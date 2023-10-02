class PostsController < ApplicationController
  before_action :set_post, only: %i[edit show update destroy]
  
  def index
    if params[:q].present?
      @posts = @query.result(distinct: true)
    else
     @original_posts = current_user.posts.includes(:user, :comments, :likes, :post_visits, image_attachment: :blob)
     @reposted_posts = current_user.reposts.includes(post: [:user, :comments, :likes, :post_visits, image_attachment: :blob]).map(&:post)

     @posts = (@original_posts + @reposted_posts).uniq.sort_by(&:created_at).reverse

     @post_likes_count = Post.joins(:likes).group('posts.id').count
     @post_comments_count = Post.joins(:comments).group('posts.id').count
   end
 end

 def new
  @post = Post.new
end

def create
  @post = Post.create(post_params)
  if @post.save
    redirect_to root_path
  else
    render :new
  end
end

def show
  @user = @post.user
  @comments = @post.comments.includes(:user).order(created_at: :desc)
    # # for visiting the post by current user
    PostVisit.create(user: current_user, post: @post)

    prepare_meta_tags(
      title: @post.title,
      description: @post.description,
      twitter: {
        card: @post.title
      },
      og: {
        url: post_path(@post),
        title: @post.title,
        image: (ENV['APP_URL'] + rails_blob_path(@post.image)),
        description: @post.description,
      }
      )
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

  def autocomplete
    query = params[:q]
    # Implement your autocomplete logic here and return a JSON response
    suggestions = Post.where("title LIKE ?", "%#{query}%").pluck(:title)
    render json: suggestions
  end

  private

  def set_post
    @post = Post.find(params[:id])
  end

  def post_params
    params.require(:post).permit(:title, :description, :user_id, :image)
  end

end
