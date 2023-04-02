require 'rails_helper'

RSpec.describe Group, type: :model do

  let(:group) { build(:group) }

  describe 'validations' do
    it 'is valid with required params' do
      expect(group).to be_valid
    end

    it 'must have a name' do
      group.name = nil
      expect(group).to be_invalid
    end

    it 'must have a creator' do
      group.creator = nil
      expect(group).to be_invalid
    end

    context 'when user creates a group' do
      let(:group_1) { create(:group) }
      let(:group_2) { build(:group, name: group_1.name, creator: group_1.creator) }

      it 'should have a unique name' do
        expect(group_2).to be_invalid
      end
    end
  end

  xcontext 'when user creates a group' do
    let(:user) { create(:user) }
    let(:group) { create(:group, creator: user) }

    it 'should also add him as a member if group' do
      expect(UserGroup.count).to eq(1)
    end
  end

  context 'when a user adds another user to group' do

    let(:existing_user) { create(:user) }
    let(:group) { create(:group, creator: existing_user) }
    let(:group_user) { create(:user_group, group: group, user: existing_user) }
    let(:new_user) { create(:user, user_name: 'test_user') }

    xit 'raises error if user is not a member of group' do
      expect{
        group.add_users([new_user.id])
      }.to raise_error
    end

    it 'add the new member' do
      expect{
        group.add_users([new_user.id])
      }.to change { UserGroup.count }.by(1)
    end
  end
end
