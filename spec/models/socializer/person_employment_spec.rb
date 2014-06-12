require 'rails_helper'

module Socializer
  RSpec.describe PersonEmployment, type: :model do
    let(:person_employment) { build(:socializer_person_employment) }

    it 'has a valid factory' do
      expect(person_employment).to be_valid
    end

    context 'mass assignment' do
      it { is_expected.to allow_mass_assignment_of(:employer_name) }
      it { is_expected.to allow_mass_assignment_of(:job_title) }
      it { is_expected.to allow_mass_assignment_of(:started_on) }
      it { is_expected.to allow_mass_assignment_of(:ended_on) }
      it { is_expected.to allow_mass_assignment_of(:current) }
      it { is_expected.to allow_mass_assignment_of(:job_description) }
    end

    context 'relationships' do
      it { is_expected.to belong_to(:person) }
    end

    context 'validations' do
      it { is_expected.to validate_presence_of(:person) }
    end
  end
end
