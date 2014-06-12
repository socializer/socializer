require 'rails_helper'

module Socializer
  RSpec.describe PersonPhone, type: :model do
    let(:person_phone) { build(:socializer_person_phone) }

    it 'has a valid factory' do
      expect(person_phone).to be_valid
    end

    context 'mass assignment' do
      it { is_expected.to allow_mass_assignment_of(:label) }
      it { is_expected.to allow_mass_assignment_of(:number) }
    end

    context 'relationships' do
      it { is_expected.to belong_to(:person) }
    end

    context 'validations' do
      it { is_expected.to validate_presence_of(:category) }
      it { is_expected.to validate_presence_of(:label) }
      it { is_expected.to validate_presence_of(:number) }
      it { is_expected.to validate_presence_of(:person) }
    end

    it { expect(enumerize(:category).in(:home, :work).with_default(:home)) }

  end
end
