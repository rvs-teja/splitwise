require 'rails_helper'

RSpec.describe Mutations::CreateGroup, type: :request do
  let(:user) { create(:user) }
  let(:headers) { auth_header(user) }
  let(:params) do
    {
      name: 'test-group',
      description: 'test group description'
    }
  end

  let(:api_call) do
    post '/graphql', params: { query:, variables: params }, headers: headers
  end

  it 'creates a group' do
    api_call

    json = JSON.parse(response.body)
    expect(JsonPath.on(json, '$..group')[0]).to include({
                                                          'name' => 'test-group',
                                                          'description' => 'test group description'
                                                        })
  end

  it 'sets user as creator for the group' do
    api_call

    expect(Group.first.creator).to eq(user)
  end

  it 'adds the creator to group' do
    expect do
      api_call
    end.to change(UserGroup, :count).by(1)
    expect(user.groups.first).to have_attributes(name: 'test-group', description: 'test group description')
  end

  def query
    <<~GQL
      mutation($name: String!, $description: String){
        createGroup(name: $name, description: $description){
          group{
            id
            name
            description
          }
        }
      }
    GQL
  end
end
