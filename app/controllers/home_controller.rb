class HomeController < ApplicationController
  def index
    @posts = Post.includes(:likes, :comments, user: [image_attachment: :blob], image_attachment: :blob).order(created_at: :desc)
    @post_likes_count = Post.joins(:likes).group('posts.id').count
    @post_comments_count = Post.joins(:comments).group('posts.id').count
  end

  def sort
    common_includes = [:likes, user: [image_attachment: :blob], image_attachment: :blob]

    sort_order = case params[:sort_by]
    when 'alphabetical'
      { order_column: :title, order_direction: :asc }
    when 'alphabetical_reverse'
      { order_column: :title, order_direction: :desc }
    when 'time_posted_reverse'
      { order_column: :created_at, order_direction: :asc }
    when 'time_posted'
      { order_column: :created_at, order_direction: :desc }
    else
      { order_column: :created_at, order_direction: :desc }
    end

    @posts = Post.includes(common_includes).order(sort_order[:order_column] => sort_order[:order_direction])
    @post_likes_count = Post.joins(:likes).group('posts.id').count
    @post_comments_count = Post.joins(:comments).group('posts.id').count

    respond_to do |format|
      format.html { render 'index' } # Render the index view with sorted posts
      format.turbo_stream
    end
  end
end