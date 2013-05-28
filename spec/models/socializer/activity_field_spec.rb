require 'spec_helper'

module Socializer
  describe ActivityField do
    pending "add more examples to #{__FILE__}"

    it { should allow_mass_assignment_of(:content) }
    it { should allow_mass_assignment_of(:activity) }
    it { should belong_to(:activity) }
    it { should validate_presence_of(:content) }
    it { should validate_presence_of(:activity) }
  end
end
