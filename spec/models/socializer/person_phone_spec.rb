require 'spec_helper'

module Socializer
  describe PersonPhone, :type => :model do
    let(:person_phone) { build(:socializer_person_phone) }

    it 'has a valid factory' do
      expect(person_phone).to be_valid
    end

    context 'mass assignment' do
      it { expect(person_phone).to allow_mass_assignment_of(:label) }
      it { expect(person_phone).to allow_mass_assignment_of(:number) }
    end

    context 'relationships' do
      it { expect(person_phone).to belong_to(:person) }
    end

    context 'validations' do
      it { expect(person_phone).to validate_presence_of(:label) }
      it { expect(person_phone).to validate_presence_of(:number) }
    end

    it { expect(enumerize(:category).in(:home, :work).with_default(:home)) }

  end
end
