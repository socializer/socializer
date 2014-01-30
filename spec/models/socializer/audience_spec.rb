require 'spec_helper'

module Socializer
  describe Audience do
    let(:audience) { build(:socializer_audience) }

    it 'has a valid factory' do
      expect(audience).to be_valid
    end

    context 'mass assignment' do
      it { expect(audience).to allow_mass_assignment_of(:activity_id) }
      it { expect(audience).to allow_mass_assignment_of(:privacy_level) }
    end

    context 'relationships' do
      it { expect(audience).to belong_to(:activity) }
      it { expect(audience).to belong_to(:activity_object) }
    end

    context 'validations' do
      it { expect(audience).to validate_presence_of(:privacy_level) }
    end

    it { expect(enumerize(:privacy_level).in(:public, :circles, :limited).with_default(:public)) }

    it '#object' do
      expect(audience).to respond_to(:object)
    end
  end
end
