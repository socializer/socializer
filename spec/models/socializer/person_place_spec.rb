require 'spec_helper'

module Socializer
  describe PersonPlace, type: :model do
    let(:person_place) { build(:socializer_person_place) }

    it 'has a valid factory' do
      expect(person_place).to be_valid
    end

    context 'mass assignment' do
      it { expect(person_place).to allow_mass_assignment_of(:city_name) }
      it { expect(person_place).to allow_mass_assignment_of(:current) }
    end

    context 'relationships' do
      it { expect(person_place).to belong_to(:person) }
    end

    context 'validations' do
      it { expect(person_place).to validate_presence_of(:city_name) }
    end

  end
end
