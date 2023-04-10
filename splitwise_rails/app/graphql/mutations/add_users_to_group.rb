module Mutations
  class AddUsersToGroup < BaseMutation

    field :status, Boolean, null: false

    argument :user_ids, [ID], required: { allow_blank: false }
    argument :group_id, ID, required: true

    def resolve(user_ids:, group_id:)
      group = Group.find_by(id: group_id)
      group_not_found unless group

      not_group_user unless group.user_ids.include?(context[:current_user].id)

      group.add_users(user_ids)
      {
        status: true
      }
    end

    private

    def group_not_found
      raise GraphQL::ExecutionError.new('Group not found', extensions: { code: 'GROUP_NOT_FOUND' })
    end

    def not_group_user
      raise GraphQL::ExecutionError.new('Must be a member of group', extensions: { code: 'NOT_GROUP_USER' })
    end
  end
end
