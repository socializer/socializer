require 'spec_helper'

module Socializer
  describe Tie do
    it 'has a valid factory' do
      expect(build(:socializer_tie)).to be_valid
    end
  end
end
