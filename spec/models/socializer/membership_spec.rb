require 'rails_helper'

module Socializer
  RSpec.describe Membership, type: :model do
    let(:user) { create(:socializer_person) }
    let(:group) { create(:socializer_group, activity_author: user.activity_object) }
    let(:membership) { create(:socializer_membership, activity_member: user.activity_object, group: group) }

    it 'has a valid factory' do
      expect(membership).to be_valid
    end

    describe 'mass assignment' do
      it { is_expected.to allow_mass_assignment_of(:group_id) }
      it { is_expected.to allow_mass_assignment_of(:active) }
    end

    describe 'relationships' do
      it { is_expected.to belong_to(:group) }
      it { is_expected.to belong_to(:activity_member) }
      # it { is_expected.to belong_to(:activity_member).class_name('ActivityObject').with_foreign_key('member_id') }
    end

    describe 'scopes' do
      context 'inactive' do
        context 'no inactive records' do
          let(:result) { Membership.inactive }

          it { expect(result).to be_kind_of(ActiveRecord::Relation) }
          it { expect(result.present?).to be false }
        end

        context 'inactive records' do
          before { create(:socializer_membership, active: false) }
          let(:result) { Membership.inactive }

          it { expect(result).to be_kind_of(ActiveRecord::Relation) }
          it { expect(result.first.active).to be false }
        end
      end

      context 'by_person' do
        context 'person has no memberships' do
          let(:user) { create(:socializer_person) }
          let(:result) { Membership.by_person(user.guid) }

          it { expect(result).to be_kind_of(ActiveRecord::Relation) }
          it { expect(result.present?).to be false }
        end

        context 'person has memberships' do
          let(:result) { Membership.by_person(user.guid) }

          before :each do
            membership
          end

          it { expect(result).to be_kind_of(ActiveRecord::Relation) }

          it 'has memberships' do
            expect(result.present?).to be true
            expect(result.first.group_id).to eq group.id
            expect(result.first.member_id).to eq user.guid
          end
        end
      end
    end

    describe '#member' do
      it { expect(membership.member).to eq(user) }
    end

    describe '#approve!' do
      it { is_expected.to respond_to(:approve!) }
    end

    describe '#confirm!' do
      it { is_expected.to respond_to(:confirm!) }
    end

    describe '#decline!' do
      it { is_expected.to respond_to(:decline!) }
    end

    describe 'when approved' do
      let(:inactive_membership) { create(:socializer_membership, active: false) }

      before do
        inactive_membership.approve!
      end

      it 'becomes active' do
        expect(inactive_membership.active).to be_truthy
      end
    end

    describe 'when confirmed' do
      let(:inactive_membership) { create(:socializer_membership, active: false) }

      before do
        inactive_membership.confirm!
      end

      it 'becomes active' do
        expect(inactive_membership.active).to be_truthy
      end
    end

    describe 'when declined' do
      let(:inactive_membership) { create(:socializer_membership, active: false) }

      before do
        inactive_membership.decline!
      end

      it 'no longer exists' do
        expect { inactive_membership.reload }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end
  end
end
