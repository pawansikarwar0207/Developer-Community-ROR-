class HomeController < ApplicationController
  def index
    @posts = Post.includes(:likes, user: [image_attachment: :blob], image_attachment: :blob).order(created_at: :desc)
    @post_likes_count = Post.joins(:likes).group('posts.id').count
  end

  def sort
    case params[:sort_by]
    when 'alphabetical'
      @posts = Post.includes(:likes, user: [image_attachment: :blob], image_attachment: :blob).order(title: :asc)
    when 'alphabetical_reverse'
      @posts = Post.includes(:likes, user: [image_attachment: :blob], image_attachment: :blob).order(title: :desc)
    when 'time_posted_reverse'
      @posts = Post.includes(:likes, user: [image_attachment: :blob], image_attachment: :blob).order(created_at: :asc)
    when 'time_posted'
      @posts = Post.includes(:likes, user: [image_attachment: :blob], image_attachment: :blob).order(created_at: :desc)
    else
      @posts = Post.includes(:likes, user: [image_attachment: :blob], image_attachment: :blob).order(created_at: :desc)
    end

    @post_likes_count = Post.joins(:likes).group('posts.id').count

    respond_to do |format|
      format.html { render 'index' } # Render the index view with sorted posts
      format.turbo_stream
    end
  end

end