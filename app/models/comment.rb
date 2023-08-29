class Comment < ApplicationRecord
  
  belongs_to :user
  belongs_to :commentable, polymorphic: true

  validates :title, presence: true

  # has_rich_text :title

  # For showing the notifications
  after_create_commit :notify_recipient
  before_destroy :cleanup_notifications
  has_noticed_notifications model_name: 'Notification'

  private

  def notify_recipient
  Rails.logger.info "Notify recipient method triggered for comment: #{self.id}"
  if commentable.is_a?(Post)
    CommentNotification.with(comment: self, post: commentable).deliver_later(commentable.user)
  end
end


  def cleanup_notifications
    notifications_as_comment.destroy_all
  end

# def notify_recipient
#   CommentNotification.with(comment: self, post: post).deliver_later(post.user)
# end
  
end
