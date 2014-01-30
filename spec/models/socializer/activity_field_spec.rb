require 'spec_helper'

module Socializer
  describe ActivityField do
    let(:activity_field) { build(:socializer_activity_field) }

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
      expect(activity_field).to be_valid
    end

    it 'is invalid without content' do
      expect(build(:socializer_activity_field, content: nil)).to be_invalid
    end

    it 'is invalid without activity' do
      expect(build(:socializer_activity_field, activity: nil)).to be_invalid
    end
  end
end
