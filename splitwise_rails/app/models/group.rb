# frozen_string_literal: true

class Group < ApplicationRecord

  # validations
  validates :name, presence: true, uniqueness: { scope: :creator, message: 'User is already a member of group' }

  # relations
  belongs_to :creator, class_name: 'User', foreign_key: 'creator_id', required: true

  has_many :user_groups
  has_many :users, through: :user_groups

  # call backs
  after_create :add_creator_to_group

  def add_users(user_ids)
    users = User.where(id: user_ids)
    raise ActiveRecord::RecordNotFound, 'One or more users not found' unless users.size == user_ids.size

    self.users << users
    save!
    true
  end

  private

  def add_creator_to_group
    transaction do
      user_group = UserGroup.create!(
        group: self,
        user: creator
      )
      raise ActiveRecord::Rollback, 'UserGroup creation failed' unless user_group.persisted?
    end
  end
end
