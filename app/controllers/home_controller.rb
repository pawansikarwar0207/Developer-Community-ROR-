class HomeController < ApplicationController
  def index
    @q = User.ransack(params[:q])
    
    if params[:country].present?
      @users = User.where(country: params[:country]).order(created_at: :asc).limit(16)
    else
      @users = @q.result(distinct: true).order(created_at: :asc).limit(16)
    end
    @users_with_images = User.where.not(image: nil)
    @posts = Post.includes(:user, :notifications, :likes, image_attachment: :blob).order(created_at: :desc)
  end
end