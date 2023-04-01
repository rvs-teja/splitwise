class Group < ApplicationRecord

  validates :name, presence: true, uniqueness: { scope: :creator }

  belongs_to :creator, class_name: 'User', foreign_key: 'creator_id'

  has_many :user_groups
  has_many :users, through: :user_groups

  def add_users(user_ids)
    users = User.where(id: user_ids)
    self.users << users
    save
  end
end
