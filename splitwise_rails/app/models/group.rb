class Group < ApplicationRecord

  validates :name, presence: true, uniqueness: { scope: :creator }

  belongs_to :creator, class_name: 'User', foreign_key: 'creator_id'
end
