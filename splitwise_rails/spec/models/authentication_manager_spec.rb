require 'rails_helper'

RSpec.describe AuthenticationManager do
  describe 'verify' do

    context 'when token in not present' do
      let(:token) { nil }

      it 'raises missing token error' do
        expect{
          AuthenticationManager.new(token).verify
        }.to raise_error(AuthenticationError, 'Missing token!')
      end

    end

    context 'when token is expired' do
      let(:user) { build(:user) }
      let(:token) { JsonWebToken.encode({ user_id: user.id }, 4.hours.ago) }

      it 'raises token invalid error' do
        expect{
          AuthenticationManager.new(token).verify
        }.to raise_error(AuthenticationError, 'Invalid token!')
      end
    end

    context 'when token is invalid' do
      let(:token) { 'invalid-token' }

      it 'raises token invalid error' do
        expect{
          AuthenticationManager.new(token).verify
        }.to raise_error(AuthenticationError, 'Invalid token!')
      end
    end

    context 'when user is invalid' do
      let(:token) { JsonWebToken.encode({ user_id: 'invalid-id' }, 4.hours.ago) }

      it 'raises an error' do
        expect{
          AuthenticationManager.new(token).verify
        }.to raise_error(AuthenticationError, 'Invalid token!')
      end
    end

    context 'when token is valid' do
      let!(:user) { create(:user) }
      let(:token) { generate_token(user) }

      it 'returns true' do
        expect(AuthenticationManager.new(token).verify).to be_truthy
      end
    end

  end


end