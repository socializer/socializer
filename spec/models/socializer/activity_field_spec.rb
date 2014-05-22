require 'spec_helper'

module Socializer
  describe ActivityField, :type => :model do
    let(:activity_field) { build(:socializer_activity_field) }

    it 'has a valid factory' do
      expect(activity_field).to be_valid
    end

    context 'mass assignment' do
      it { expect(activity_field).to allow_mass_assignment_of(:content) }
      it { expect(activity_field).to allow_mass_assignment_of(:activity) }
    end

    context 'relationships' do
      it { expect(activity_field).to belong_to(:activity) }
    end

    context 'validations' do
      it { expect(activity_field).to validate_presence_of(:content) }
      it { expect(activity_field).to validate_presence_of(:activity) }
    end
  end
end
