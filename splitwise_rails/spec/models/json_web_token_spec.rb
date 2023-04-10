require 'rails_helper'

RSpec.describe JsonWebToken do

  let(:user) { build(:user) }
  let(:payload) do
    { user_id: user.id }
  end
  let(:token) { JsonWebToken.encode(payload)  }

  describe 'encode' do
    it 'returns the token' do
      expect(token).not_to be_nil
    end
  end

  describe 'decode' do

    it 'returns decoded values from token' do
      expect(JsonWebToken.decode(token)).to include({ user_id: user.id })
    end

    it 'return empty values for invalid token' do
      token = 'invalid-token'
      expect(JsonWebToken.decode(token)).to be_empty
    end

  end

end