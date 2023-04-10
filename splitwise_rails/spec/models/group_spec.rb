require 'rails_helper'

RSpec.describe Group, type: :model do

  describe 'validations' do

    let(:group) { build(:group) }

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
  end

  context 'when group is created successfully' do

    let(:creator) { create(:user) }
    let(:group) { create(:group, creator: creator ) }

    it 'adds the user to the group' do
      expect(group.users.first).to eq(creator)
    end
  end

  context 'when user tries to create another group with same name' do
    let!(:current_user) { create(:user) }
    let!(:group) { create(:group, creator: current_user) }
    let(:group_1) { build(:group, creator: current_user) }

    it 'raises an error' do
      expect(group_1).to be_invalid
    end
  end

  describe 'when a user adds another user to group' do

    let!(:user) { create(:user) }
    let!(:group) { create(:group, creator: user) }
    let!(:new_user) { create(:user, user_name: 'new-user') }

    it 'adds the new members' do
      expect {
        group.add_users([new_user.id])
      }.to change { UserGroup.count }.by(1)
    end

    context 'when user is already a member of group' do
      let!(:group_user) { create(:user_group, user: new_user, group: group) }

      it 'raises an error' do
        expect {
          group.add_users([new_user.id])
        }.to raise_error(ActiveRecord::RecordInvalid)
      end
    end

    context 'when user is not found' do
      let!(:new_user) { build(:user, id: 'invalid-user') }

      it 'raises an error' do
        expect {
          group.add_users([new_user.id])
        }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end
  end
end
