require 'rails_helper'

module Socializer
  RSpec.describe Verb, type: :model do
    let(:verb) { build(:socializer_verb) }

    it 'has a valid factory' do
      expect(verb).to be_valid
    end

    context 'mass assignment' do
      it { is_expected.to allow_mass_assignment_of(:name) }
    end

    context 'relationships' do
      it { is_expected.to have_many(:activities) }
    end

    context 'validations' do
      it { is_expected.to validate_presence_of(:name) }
      it { is_expected.to validate_uniqueness_of(:name) }
    end
  end
end
