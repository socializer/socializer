require 'spec_helper'

module Socializer
  describe Group do
    pending "add additional examples to #{__FILE__}"

    it { should allow_mass_assignment_of(:name) }
    it { should allow_mass_assignment_of(:privacy_level) }

    it { should enumerize(:privacy_level).in(:public, :restricted, :private).with_default(:public) }
  end
end
