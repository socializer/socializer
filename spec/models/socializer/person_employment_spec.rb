require 'spec_helper'

module Socializer
  RSpec.describe PersonEmployment, type: :model do
    let(:person_employment) { build(:socializer_person_employment) }

    it 'has a valid factory' do
      expect(person_employment).to be_valid
    end

    context 'mass assignment' do
      it { expect(person_employment).to allow_mass_assignment_of(:employer_name) }
      it { expect(person_employment).to allow_mass_assignment_of(:job_title) }
      it { expect(person_employment).to allow_mass_assignment_of(:start) }
      it { expect(person_employment).to allow_mass_assignment_of(:end) }
      it { expect(person_employment).to allow_mass_assignment_of(:current) }
      it { expect(person_employment).to allow_mass_assignment_of(:job_description) }
    end

    context 'relationships' do
      it { expect(person_employment).to belong_to(:person) }
    end

  end
end
