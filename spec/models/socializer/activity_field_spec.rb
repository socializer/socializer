require 'spec_helper'

module Socializer
  describe ActivityField do
    # TODO: shoulda-matchers - replace should allow_mass_assignment_of with new expect syntax
    #       with the next release of shoulda-matchers
    # expect(ActivityField).to allow_mass_assignment_of(::content)
    # expect(ActivityField).to allow_mass_assignment_of(::activity)
    it { should allow_mass_assignment_of(:content) }
    it { should allow_mass_assignment_of(:activity) }
    it { should belong_to(:activity) }
    it { should validate_presence_of(:content) }
    it { should validate_presence_of(:activity) }

    it 'has a valid factory' do
      expect(create(:socializer_activity_field)).to be_valid
    end

    it 'is valid with content' do
      expect(build(:socializer_activity_field, content: 'this is content')).to be_valid
    end

    it 'is invalid without content' do
      expect(build(:socializer_activity_field, content: nil)).to have(1).errors_on(:content)
    end

    it 'is valid with activity' do
      expect(build(:socializer_activity_field, activity: FactoryGirl.build(:socializer_activity))).to be_valid
    end

    it 'is invalid without activity' do
      expect(build(:socializer_activity_field, activity: nil)).to have(1).errors_on(:activity)
    end
  end
end
