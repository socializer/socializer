require 'spec_helper'

module Socializer
  describe Membership do
    it 'has a valid factory' do
      expect(build(:socializer_membership)).to be_valid
    end
  end
end
