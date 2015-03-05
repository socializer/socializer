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
      it { is_expected.to belong_to(:activity).inverse_of(:audiences) }
      it { is_expected.to belong_to(:activity_object).inverse_of(:audiences) }
    end

    context 'validations' do
      it { is_expected.to validate_presence_of(:privacy) }
      # it { is_expected.to validate_presence_of(:activity_id) }
      # it { is_expected.to validate_uniqueness_of(:activity_id).scoped_to(:activity_object_id) }
      # it { expect(create(:socializer_audience)).to validate_uniqueness_of(:activity_id).scoped_to(:activity_object_id) }
    end

    it { is_expected.to enumerize(:privacy).in(:public, :circles, :limited).with_default(:public) }

    context '#object' do
      let(:activitable) { audience.activity_object.activitable }
      it { expect(audience.object).to be_a(activitable.class) }
      it { expect(audience.object).to eq(activitable) }
    end
  end
end
