require 'spec_helper'

module Socializer
  RSpec.describe ActivityField, type: :model do
    let(:activity_field) { build(:socializer_activity_field) }

    it 'has a valid factory' do
      expect(activity_field).to be_valid
    end

    context 'mass assignment' do
      it { is_expected.to allow_mass_assignment_of(:content) }
      it { is_expected.to allow_mass_assignment_of(:activity) }
    end

    context 'relationships' do
      it { is_expected.to belong_to(:activity) }
    end

    context 'validations' do
      it { is_expected.to validate_presence_of(:content) }
      it { is_expected.to validate_presence_of(:activity) }
    end
  end
end
