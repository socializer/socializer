require 'spec_helper'

module Socializer
  describe PersonAddress do
    let(:person_address) { build(:socializer_person_address) }

    it 'has a valid factory' do
      expect(person_address).to be_valid
    end

    context 'mass assignment' do
      it { expect(person_address).to allow_mass_assignment_of(:line1) }
      it { expect(person_address).to allow_mass_assignment_of(:line2) }
      it { expect(person_address).to allow_mass_assignment_of(:city) }
      it { expect(person_address).to allow_mass_assignment_of(:postal_code_or_zip) }
      it { expect(person_address).to allow_mass_assignment_of(:province_or_state) }
      it { expect(person_address).to allow_mass_assignment_of(:country) }
    end

    context 'relationships' do
      it { expect(person_address).to belong_to(:person) }
    end

    it { expect(enumerize(:category).in(:home, :work).with_default(:home)) }

  end
end
