# frozen_string_literal: true

module Mutations
  class CreateGroup < BaseMutation
    field :group, Types::GroupType

    argument :name, String, required: true
    argument :description, String, required: false

    def resolve(name:, description:)
      group = Group.new(
        name:,
        description:,
        creator: context[:current_user]
      )
      raise GraphQL::ExecutionError, group.errors.full_messages.join(',') unless group.save

      {
        group: group
      }
    end
  end
end
