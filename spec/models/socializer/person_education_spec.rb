require 'spec_helper'

module Socializer
  RSpec.describe PersonEducation, type: :model do
    let(:person_education) { build(:socializer_person_education) }

    it 'has a valid factory' do
      expect(person_education).to be_valid
    end

    context 'mass assignment' do
      it { expect(person_education).to allow_mass_assignment_of(:school_name) }
      it { expect(person_education).to allow_mass_assignment_of(:major_or_field_of_study) }
      it { expect(person_education).to allow_mass_assignment_of(:start) }
      it { expect(person_education).to allow_mass_assignment_of(:end) }
      it { expect(person_education).to allow_mass_assignment_of(:current) }
      it { expect(person_education).to allow_mass_assignment_of(:courses_description) }
    end

    context 'relationships' do
      it { expect(person_education).to belong_to(:person) }
    end

  end
end
