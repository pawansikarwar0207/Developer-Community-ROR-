class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
  :recoverable, :rememberable, :validatable, :trackable

  validate :validate_country

  has_many :work_experiences, dependent: :destroy
  has_many :connections, dependent: :destroy
  
  has_many :posts, dependent: :destroy

  has_many :comments, as: :commentable

  # For showing the notifications
  has_many :notifications, as: :recipient, dependent: :destroy


  PROFILE_TITLE = [
    'Senior Ruby on Rails Developer',
    'Full Stack Ruby on Rails Developer',
    'Senior Full Stack Ruby on Rails Developer',
    'Junior Full Stack Ruby on Rails Developer',
    'Senior Java Developer',
    'Senior Front End Developer'
  ].freeze

  def name
    "#{first_name} #{last_name}".strip
  end

  def address
    "#{city}, #{state}, #{country}, #{pincode}"
  end

  def self.ransackable_attributes(auth_object = nil)
    ["country", "city"]
  end

  def self.ransackable_associations(auth_object = nil)
    []
  end


  def validate_country
    return if country.nil?

    unless ISO3166::Country.all.map { |country| country.alpha2 }.include?(country)
      errors.add(:country, 'is not valid')
    end
  end

  # def country_name
  #   country = ISO3166::Country[country_code]
  #   country.translations[I18n.locale.to_s] || country.name
  # end

  def country_name
     c = ISO3166::Country[self.country]
     return c.translations[I18n.locale.to_s] || c.name
  end

  def my_connection(user)
    Connection.where("(user_id = ? AND connected_user_id = ? ) OR (user_id = ? AND connected_user_id = ? )", user.id, id, id, user.id)
  end

  def check_if_already_connected?(user)
    self != user && !my_connection(user).present?
  end

  def mutually_connected_ids(user)
    self.connected_user_ids.intersection(user.connected_user_ids)
  end
  
end
