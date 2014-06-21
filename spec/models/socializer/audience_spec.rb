require 'rails_helper'

module Socializer
  RSpec.describe Audience, type: :model do
    let(:audience) { build(:socializer_audience) }

    it 'has a valid factory' do
      expect(audience).to be_valid
    end

    context 'mass assignment' do
      it { is_expected.to allow_mass_assignment_of(:activity_id) }
      it { is_expected.to allow_mass_assignment_of(:privacy) }
    end

    context 'relationships' do
      it { is_expected.to belong_to(:activity) }
      it { is_expected.to belong_to(:activity_object) }
    end

    context 'validations' do
      it { is_expected.to validate_presence_of(:privacy) }
      # it { is_expected.to validate_presence_of(:activity_id) }
      # it { is_expected.to validate_uniqueness_of(:activity_id).scoped_to(:activity_object_id) }
      # it { expect(create(:socializer_audience)).to validate_uniqueness_of(:activity_id).scoped_to(:activity_object_id) }
    end

    it { expect(enumerize(:privacy).in(:public, :circles, :limited).with_default(:public)) }

    context '.audience_list' do
      it 'is a pending example'
      it { expect { Audience.audience_list }.to raise_error(ArgumentError) }

      context 'current user' do
        let(:current_user) { create(:socializer_person) }
        let(:circles) { create(:socializer_person_circles) }
        let(:groups) { create(:socializer_person_groups) }

        # TODO: Test return values
        context 'but no query' do
          it { expect { Audience.audience_list(current_user) }.to raise_error(ArgumentError) }
          it { expect(Audience.audience_list(current_user, nil)).to be_kind_of(Array) }
        end

        # TODO: Test return values
        context 'with query' do
          it { expect(Audience.audience_list(current_user, 'n')).to be_kind_of(Array) }
        end
      end
    end

    context '#object' do
      let(:activitable) { audience.activity_object.activitable }
      it { expect(audience.object).to be_a(activitable.class) }
      it { expect(audience.object).to eq(activitable) }
    end

    context 'privacy_hash returns a hash' do
      let(:public_hash) { { id: 1, name: 'Public' } }
      it { expect(Audience.privacy_hash(:public)).to be_a(Hash) }
      it { expect(Audience.privacy_hash(:public)).to eq(public_hash) }
      it { expect(Audience.privacy_hash('Public')).to eq(public_hash) }
      it { expect(Audience.privacy_hash(:circles)).to_not eq(public_hash) }
    end
  end
end
