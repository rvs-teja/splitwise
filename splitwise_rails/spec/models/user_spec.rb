require 'rails_helper'

RSpec.describe User, type: :model do

  let(:user) { build(:user) }

  describe 'validations' do
    it 'is valid with required parameters' do
      expect(user).to be_valid
    end

    it 'must have a user name' do
      user.user_name = nil
      expect(user).to be_invalid
    end

    it 'must have a password' do
      user.password = nil
      expect(user).to be_invalid
    end

  end
end
