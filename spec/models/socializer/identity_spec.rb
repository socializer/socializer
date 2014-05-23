require 'spec_helper'

module Socializer
  RSpec.describe Identity, type: :model do
    let(:identity) { build(:socializer_identity) }

    it 'has a valid factory' do
      expect(identity).to be_valid
    end

    context 'mass assignment' do
      it { is_expected.to allow_mass_assignment_of(:name) }
      it { is_expected.to allow_mass_assignment_of(:email) }
      it { is_expected.to allow_mass_assignment_of(:password) }
      it { is_expected.to allow_mass_assignment_of(:password_confirmation) }
    end

    context 'validations' do
      it { is_expected.to validate_presence_of(:name) }
      it { is_expected.to validate_presence_of(:email) }
      it { is_expected.to validate_uniqueness_of(:email) }
    end

    it { is_expected.to respond_to(:password) }
    it { is_expected.to respond_to(:password_confirmation) }
  end
end
