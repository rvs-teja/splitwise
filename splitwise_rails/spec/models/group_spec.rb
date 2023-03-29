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
end
