require 'rails_helper'

RSpec.describe Mutations::Login, type: :request do

  let!(:user) { create(:user, user_name: 'User', password: 'Password') }

  let(:params) do
    {
      userName: user.user_name,
      password: user.password
    }
  end

  let(:api_call) {
    post '/graphql', params: { query: query, variables: params }
  }

  context 'when user name and password is correct' do

    before do
      allow(JsonWebToken).to receive(:encode).and_return('test-token')
    end

    it 'returns the token' do
      api_call

      json = JSON.parse(response.body)
      token = JsonPath.on(json, '$..token')[0]
      expect(token).to eq('test-token')
    end
  end

  describe 'when wrong credentials are provided' do

    shared_examples 'invalid credentials' do |message, parameter|
      it 'raises an error' do
        api_call

        json = JSON.parse(response.body)
        errors = JsonPath.on(json, '$..errors')[0][0]
        expect(errors['message']).to eq(message)
        expect(errors['extensions']).to include({
                                                  'code' => 'AUTHENTICATION_ERROR',
                                                  'parameter' => parameter
                                                })


      end
    end

    context 'when user name is not a valid one' do

      let(:params) do
        {
          userName: 'invalid-user',
          password: 'invalid-password'
        }
      end

      it_behaves_like 'invalid credentials', 'Enter a valid user name', 'user name'
    end

    context 'when password is not a valid one' do

      let(:params) do
        {
          userName: 'User',
          password: 'invalid-password'
        }
      end

      it_behaves_like 'invalid credentials', 'Enter a valid password', 'password'
    end



  end


  def query
    <<-GRAPHQL
      mutation($userName: String!, $password: String!){
        login(userName: $userName, password: $password){
          token
        }
      }
    GRAPHQL
  end
end