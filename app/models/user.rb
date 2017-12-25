class User < ApplicationRecord
  has_many :exercises
  has_many :friendships
  has_many :friends, through: :friendships, class_name: 'User'

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  validates :first_name, presence: true
  validates :last_name, presence: true

  self.per_page = 5

  def self.search_by_name(name)
    names = name.split(' ')

    if names.size == 1
      where('first_name LIKE ? OR last_name LIKE ?', "%#{names[0]}%", "%#{names[0]}%").order(:first_name)
    else
      query_string = 'first_name LIKE ? OR last_name LIKE ?'
      where("#{query_string} OR #{query_string}",
        "%#{names[0]}%", "%#{names[1]}%", "%#{names[1]}%", "%#{names[0]}%").order(:first_name)
    end
  end

  def full_name
    "#{first_name} #{last_name}"
  end

  def follows_or_same?(other_user)
    friendships.map(&:friend).include?(other_user) || self == other_user
  end
end
