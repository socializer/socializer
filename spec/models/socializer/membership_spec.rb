require 'spec_helper'

module Socializer
  describe Membership do
    let(:membership) { build(:socializer_membership) }

    it 'has a valid factory' do
      expect(membership).to be_valid
    end

    it '#member' do
      expect(membership).to respond_to(:member)
    end

    it '#group' do
      expect(membership).to respond_to(:group)
    end

    it '#approve!' do
      expect(membership).to respond_to(:approve!)
    end

    it '#confirm!' do
      expect(membership).to respond_to(:confirm!)
    end

    it '#decline!' do
      expect(membership).to respond_to(:decline!)
    end

    context 'when approved' do
      let(:inactive_membership) { create(:socializer_membership, active: false) }

      before do
        inactive_membership.approve!
      end

      it 'becomes active' do
        expect(inactive_membership.active).to be_true
      end
    end

    context 'when confirmed' do
      let(:inactive_membership) { create(:socializer_membership, active: false) }

      before do
        inactive_membership.confirm!
      end

      it 'becomes active' do
        expect(inactive_membership.active).to be_true
      end
    end

    context 'when declined' do
      let(:inactive_membership) { create(:socializer_membership, active: false) }

      before do
        inactive_membership.decline!
      end

      it 'no longer exists' do
        expect{ inactive_membership.reload }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end

  end
end
