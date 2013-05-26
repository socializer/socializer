require 'spec_helper'

module Socializer
  describe Verb do
    it { should allow_mass_assignment_of(:name) }
    # it { should have_many(:activities) }
    it { should validate_uniqueness_of(:name) }
    it { should validate_presence_of(:name) }

    it "has a valid factory" do
      expect(create(:socializer_verb)).to be_valid
    end

    it "is valid without a name" do
      expect(build(:socializer_verb, name: 'post')).to be_valid
    end

    it "is invalid without a name" do
      expect(build(:socializer_verb, name: nil)).to have(1).errors_on(:name)
    end

    it "is invalid with a duplicate name" do
      expect(create(:socializer_verb, name: 'post')).to be_valid
      expect(build(:socializer_verb, name: 'post')).to have(1).errors_on(:name)
    end
  end
end
