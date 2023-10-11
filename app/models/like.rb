class Like < ApplicationRecord
  belongs_to :user
  belongs_to :post

  include Notificable

  def user_ids
    # User.where.not(id: self.user_id).ids
    User.all.ids
  end


end
