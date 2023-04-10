module Types
  class MutationType < Types::BaseObject
    field :add_users_to_group, mutation: Mutations::AddUsersToGroup
    field :create_group, mutation: Mutations::CreateGroup
    field :login, mutation: Mutations::Login
  end
end
