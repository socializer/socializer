require 'spec_helper'

module Socializer
  RSpec.describe Tie, type: :model do
    let(:tie) { build(:socializer_tie) }

    it 'has a valid factory' do
      expect(tie).to be_valid
    end

    context 'mass assignment' do
      it { is_expected.to allow_mass_assignment_of(:contact_id) }
    end

    context 'relationships' do
      it { is_expected.to belong_to(:circle) }
      it { is_expected.to belong_to(:activity_contact) }
    end

    it { is_expected.to respond_to(:contact) }
  end
end
