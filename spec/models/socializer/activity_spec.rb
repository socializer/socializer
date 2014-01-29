require 'spec_helper'

module Socializer
  describe Activity do
    it 'has a valid factory' do
      expect(build(:socializer_activity)).to be_valid
    end
  end
end
