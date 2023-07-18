class HomeController < ApplicationController
  def index
    @q = User.ransack(params[:q])
    @users = @q.result(distinct: true).order(created_at: :asc).limit(16)
  end
end
