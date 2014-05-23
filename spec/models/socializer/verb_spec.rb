require 'spec_helper'

module Socializer
  RSpec.describe Verb, type: :model do
    let(:verb) { build(:socializer_verb) }

    it 'has a valid factory' do
      expect(verb).to be_valid
    end

    context 'mass assignment' do
      it { expect(verb).to allow_mass_assignment_of(:name) }
    end

    context 'relationships' do
      it { expect(verb).to have_many(:activities) }
    end

    context 'validations' do
      it { expect(verb).to validate_presence_of(:name) }
      it { expect(create(:socializer_verb, name: 'post')).to validate_uniqueness_of(:name) }
    end
  end
end
