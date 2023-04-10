module Queries
  class GroupsQuery < Queries::BaseQuery

    type [Types::GroupType], null: true

    argument :ids, [ID], required: false, default_value: []

    def resolve(**params)
      groups = Group.joins(:users).where(users: { id: context[:current_user].id })
      groups = groups.where(groups: { id: params[:ids] }) unless params[:ids].blank?
      groups
    end
  end
end