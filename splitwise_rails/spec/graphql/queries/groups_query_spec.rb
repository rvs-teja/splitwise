require 'rails_helper'

RSpec.describe Queries::GroupsQuery, type: :request do

  let(:user) { create(:user) }
  let(:headers) { auth_header(user) }
  let(:api_call) do
    post '/graphql', params: { query: query, variables: params }, headers: headers
  end

  let!(:group_1) { create(:group) }
  let!(:group_2) { create(:group) }
  let!(:group_3) { create(:group) }
  let!(:group_user_1) { create(:user_group, user: user, group: group_1) }
  let!(:group_user_2) { create(:user_group, user: user, group: group_2) }
  let!(:group_user_3) { create(:user_group, user: user, group: group_3) }

  context 'when filter by user ids' do
    let(:params) do
      {
        ids: [group_1.id, group_2.id]
      }
    end

    it 'returns groups with id' do
      api_call

      json = JSON.parse(response.body)
      expect(JsonPath.on(json, '..groups..id')).to match_array([group_1.id, group_2.id])
    end
  end

  context 'when no filters' do
    let(:params) { {} }
    it 'returns all the groups' do
      api_call

      json = JSON.parse(response.body)
      expect(JsonPath.on(json, '..groups..id')).to match_array([group_1.id, group_2.id, group_3.id])
    end

  end

  def query
    <<~GQL
      query($ids: [ID!]){
        groups(ids: $ids){
          id
          name
          description
        }
      }
    GQL
  end
end