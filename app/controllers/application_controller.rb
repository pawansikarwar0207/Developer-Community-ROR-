class ApplicationController < ActionController::Base
  before_action :set_notifications, if: :current_user
  before_action :set_query

  def set_query
    @query = Post.ransack(params[:q])
  end

  private

  def set_notifications
    notifications = Notification.includes(:recipient).where(recipient: current_user).newest_first.limit(9)
    @unread = notifications.unread
    @read = notifications.read
  end

  def render_turbo_stream(action, target, partial = nil, locals = {})
    respond_to do |format|
      format.turbo_stream do
        case action
        when 'replace'
          render turbo_stream: turbo_stream.replace(target, partial: partial, locals: locals)
        when 'appned'
          render turbo_stream: turbo_stream.append(target, partial: partial, locals: locals)
        when 'remove'
          render turbo_stream: turbo_stream.remove(target)
        end
      end
    end
  end
  
end
