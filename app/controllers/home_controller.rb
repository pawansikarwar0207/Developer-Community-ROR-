class HomeController < ApplicationController
  def index
    @q = User.ransack(params[:q])
    if params[:country].present?
      @users = User.where(country: params[:country]).order(created_at: :asc).limit(16)
    else
      @users = @q.result(distinct: true).order(created_at: :asc).limit(16)
    end
    @posts = Post.all.order(created_at: :desc)
  end

end
