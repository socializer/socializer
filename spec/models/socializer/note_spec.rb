require 'rails_helper'

module Socializer
  RSpec.describe Note, type: :model do
    let(:note) { build(:socializer_note) }

    it 'has a valid factory' do
      expect(note).to be_valid
    end

    context 'mass assignment' do
      it { is_expected.to allow_mass_assignment_of(:content) }
    end

    context 'relationships' do
      it { is_expected.to belong_to(:activity_author) }
    end

    # TODO: Test return values
    it { expect(note.author).to be_kind_of(Socializer::Person) }
  end
end
