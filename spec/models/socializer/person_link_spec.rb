require 'spec_helper'

module Socializer
  RSpec.describe PersonLink, type: :model do
    let(:person_link) { build(:socializer_person_link) }

    it 'has a valid factory' do
      expect(person_link).to be_valid
    end

    context 'mass assignment' do
      it { is_expected.to allow_mass_assignment_of(:label) }
      it { is_expected.to allow_mass_assignment_of(:url) }
    end

    context 'relationships' do
      it { is_expected.to belong_to(:person) }
    end

    context 'validations' do
      it { is_expected.to validate_presence_of(:label) }
      it { is_expected.to validate_presence_of(:url) }
    end

  end
end
