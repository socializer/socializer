require 'spec_helper'

module Socializer
  describe PersonProfile, :type => :model do
    let(:person_profile) { build(:socializer_person_profile) }

    it 'has a valid factory' do
      expect(person_profile).to be_valid
    end

    context 'mass assignment' do
      it { expect(person_profile).to allow_mass_assignment_of(:label) }
      it { expect(person_profile).to allow_mass_assignment_of(:url) }
    end

    context 'relationships' do
      it { expect(person_profile).to belong_to(:person) }
    end

    context 'validations' do
      it { expect(person_profile).to validate_presence_of(:label) }
      it { expect(person_profile).to validate_presence_of(:url) }
    end

  end
end
