require 'spec_helper'

module Socializer
  describe Note do
    let(:note) { build(:socializer_note) }

    it 'has a valid factory' do
      expect(note).to be_valid
    end

    context 'mass assignment' do
      it { expect(note).to allow_mass_assignment_of(:content) }
    end

    context 'relationships' do
      it { expect(note).to belong_to(:activity_author) }
    end

    it '#author' do
      expect(note).to respond_to(:author)
    end
  end
end
