class UserGroup < ApplicationRecord
  belongs_to :group
  belongs_to :user

  validates :user_id, presence: true, uniqueness: { scope: :group_id }
end
