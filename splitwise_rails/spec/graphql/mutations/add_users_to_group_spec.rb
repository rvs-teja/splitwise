require 'rails_helper'

RSpec.describe Mutations::AddUsersToGroup, type: :request do

  let(:user) { create(:user) }
  let(:headers) { auth_header(user) }

  let(:api_call) do
    post '/graphql', params: { query: query, variables: params }, headers: headers
  end

  context 'when non group user tries to add user' do

    let!(:user_1) { create(:user, user_name: 'user-1') }
    let!(:user_2) { create(:user, user_name: 'user-2') }
    let!(:group) { create(:group, creator: user_1) }

    let(:params) do
      {
        user_ids: [user_2.id],
        group_id: group.id
      }
    end

    it 'raises an error' do
      api_call

      json = JSON.parse(response.body)
      expect(JsonPath.on(json, '$..message')[0]).to eq('Must be a member of group')
      expect(JsonPath.on(json, '$..code')[0]).to eq('NOT_GROUP_USER')
    end
  end

  describe 'when user if a group member' do
    let(:group) { create(:group, creator: user) }

    context 'when group is not present' do

      let(:params) do
        {
          user_ids: ['invalid-id'],
          group_id: 'invalid-group'
        }
      end

      it 'raises an error' do
        api_call

        json = JSON.parse(response.body)
        expect(JsonPath.on(json, '$..addUsersToGroup')[0]).to be_nil
        expect(JsonPath.on(json, '$..code')[0]).to eq('GROUP_NOT_FOUND')
        expect(JsonPath.on(json, '$..message')[0]).to eq('Group not found')
      end
    end

    context 'when invalid user_ids are passed' do
      let(:params) do
        {
          user_ids: ['invalid-id'],
          group_id: group.id
        }
      end

      it 'raises an error' do
        api_call

        json = JSON.parse(response.body)
        expect(JsonPath.on(json, '$..addUsersToGroup')[0]).to be_nil
        expect(JsonPath.on(json, '$..code')[0]).to eq('RECORD_NOT_FOUND')
        expect(JsonPath.on(json, '$..message')[0]).to eq('One or more users not found')
      end
    end

    context 'when user tries to add an existing user' do
      let!(:user_group) { create(:user_group, group: group) }
      let(:params) do
        {
          user_ids: [user_group.user.id],
          group_id: group.id
        }
      end

      it 'raises an error' do
        api_call

        json = JSON.parse(response.body)
        expect(JsonPath.on(json, '$..addUsersToGroup')[0]).to be_nil
        expect(JsonPath.on(json, '$..code')[0]).to eq('RECORD_INVALID')
        expect(JsonPath.on(json, '$..message')[0]).to eq('Validation failed: User has already been taken')
      end
    end

    context 'add the user to group' do
      let!(:user_1) { create(:user) }
      let(:params) do
        {
          user_ids: [user_1.id],
          group_id: group.id
        }
      end

      it 'returns true' do
        api_call

        json = JSON.parse(response.body)
        expect(JsonPath.on(json, '$..status')[0]).to be_truthy
      end
    end
  end

  def query
    <<~GQL
      mutation($user_ids: [ID!], $group_id: ID!){
        addUsersToGroup(userIds: $user_ids, groupId: $group_id){
          status
        }
      }
    GQL
  end
end