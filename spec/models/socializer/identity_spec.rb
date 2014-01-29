require 'spec_helper'

module Socializer
  describe Identity do
    it 'has a valid factory' do
      expect(build(:socializer_identity)).to be_valid
    end
  end
end
