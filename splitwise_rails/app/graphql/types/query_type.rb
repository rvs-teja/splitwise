module Types
  class QueryType < Types::BaseObject
    # include GraphQL::Types::Relay::HasNodeField
    # include GraphQL::Types::Relay::HasNodesField
    field :groups, resolver: Queries::GroupsQuery
  end
end
