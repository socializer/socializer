require 'spec_helper'

module Socializer
  RSpec.describe PersonContribution, type: :model do
    let(:person_contribution) { build(:socializer_person_contribution) }

    it 'has a valid factory' do
      expect(person_contribution).to be_valid
    end

    context 'mass assignment' do
      it { expect(person_contribution).to allow_mass_assignment_of(:label) }
      it { expect(person_contribution).to allow_mass_assignment_of(:url) }
      it { expect(person_contribution).to allow_mass_assignment_of(:current) }
    end

    context 'relationships' do
      it { expect(person_contribution).to belong_to(:person) }
    end

    context 'validations' do
      it { expect(person_contribution).to validate_presence_of(:label) }
      it { expect(person_contribution).to validate_presence_of(:url) }
    end

  end
end
