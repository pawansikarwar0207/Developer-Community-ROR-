class Comment < ApplicationRecord
  
  belongs_to :user
  belongs_to :commentable, polymorphic: true

  validates :title, presence: true

  include Notificable

  def user_ids
    # User.where.not(id: self.user_id).ids
    User.all.ids
  end
  
end
