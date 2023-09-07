class Post < ApplicationRecord
  belongs_to :user
  has_one_attached :image

  validates :title, presence: true
  validates :description, presence: true

  has_many :comments, as: :commentable

  # For showing the notifications
  has_noticed_notifications model_name: 'Notification'
  has_many :notifications, through: :user

  # for posts likes
  has_many :likes, dependent: :destroy
  has_many :users, through: :likes

  def self.ransackable_attributes(auth_object = nil)
    ["created_at", "description", "id", "title", "updated_at", "user_id"]
  end

  def self.ransackable_associations(auth_object = nil)
    ["comments", "image_attachment", "image_blob", "notifications", "user"]
  end
  
end
