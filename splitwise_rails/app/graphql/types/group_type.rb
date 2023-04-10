# frozen_string_literal: true

module Types
  class GroupType < Types::BaseObject
    field :id, ID, null: false
    field :name, String, null: false
    field :description, String
  end
end
