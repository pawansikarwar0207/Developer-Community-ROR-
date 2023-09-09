class HomeController < ApplicationController
  def index
    @posts = Post.includes(:likes, user: [image_attachment: :blob], image_attachment: :blob).order(created_at: :desc)
    @post_likes_count = Post.joins(:likes).group('posts.id').count
  end
end