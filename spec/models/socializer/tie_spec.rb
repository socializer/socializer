require 'spec_helper'

module Socializer
  describe Tie, type: :model do
    let(:tie) { build(:socializer_tie) }

    it 'has a valid factory' do
      expect(tie).to be_valid
    end

    context 'mass assignment' do
      it { expect(tie).to allow_mass_assignment_of(:contact_id) }
    end

    context 'relationships' do
      it { expect(tie).to belong_to(:circle) }
      it { expect(tie).to belong_to(:activity_contact) }
    end

    it '#contact' do
      expect(tie).to respond_to(:contact)
    end
  end
end
