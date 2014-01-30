require 'spec_helper'

module Socializer
  describe Verb do
    let(:verb) { build(:socializer_verb) }

    # TODO: shoulda-matchers - replace should allow_mass_assignment_of with new expect syntax
    #       with the next release of shoulda-matchers
    # expect(Verb).to allow_mass_assignment_of(:name)
    it { should allow_mass_assignment_of(:name) }
    it { should have_many(:activities) }
    it { should validate_uniqueness_of(:name) }
    it { should validate_presence_of(:name) }

    it 'has a valid factory' do
      expect(verb).to be_valid
    end

    it 'is valid with a name' do
      expect(build(:socializer_verb, name: 'post')).to be_valid
    end

    it 'is invalid without a name' do
      expect(build(:socializer_verb, name: nil)).to have(1).errors_on(:name)
    end

    it 'is invalid with a duplicate name' do
      expect(create(:socializer_verb, name: 'post')).to be_valid
      expect(build(:socializer_verb, name: 'post')).to have(1).errors_on(:name)
    end
  end
end
