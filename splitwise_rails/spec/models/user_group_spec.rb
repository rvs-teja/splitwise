require 'rails_helper'

RSpec.describe UserGroup, type: :model do

  let(:user_group) { build(:user_group) }

  describe 'validations' do
    it 'is valid with required params' do
      expect(user_group).to be_valid
    end

    it 'must have a user' do
      user_group.user = nil
      expect(user_group).to be_invalid
    end

    it 'must have a group' do
      user_group.group = nil
      expect(user_group).to be_invalid
    end
  end

  context 'when existing user is being added to a group' do
    let(:user) { create(:user) }
    let(:group) { create(:group) }
    let!(:user_group) { create(:user_group, user: user, group: group) }
    let(:user_group_1) { build(:user_group, user: user, group: group) }

    it 'must raise an error' do
      expect(user_group_1).to be_invalid
    end
  end
end
