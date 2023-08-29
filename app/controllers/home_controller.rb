class HomeController < ApplicationController
  def index
    @q = User.ransack(params[:q])
    if params[:country].present?
      @users = User.includes(:connections, :posts, :comments, :notifications).where(country: params[:country]).order(created_at: :asc).limit(16)
    else
      @users = @q.result(distinct: true).includes(:connections, :posts, :comments, :notifications).order(created_at: :asc).limit(16)
    end
    @posts = Post.includes(:user, :comments, :notifications, image_attachment: :blob).order(created_at: :desc)
  end
end