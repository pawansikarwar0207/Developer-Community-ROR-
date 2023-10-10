class NotificationsController < ApplicationController
  before_action :authenticate_user!

  def index
    @notifications = current_user.notifications.includes(:user, :item)
    @notifications.update(viewed: true)
  end
end
