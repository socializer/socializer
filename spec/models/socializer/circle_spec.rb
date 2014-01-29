require 'spec_helper'

module Socializer
  describe Circle do
    it 'has a valid factory' do
      expect(build(:socializer_circle)).to be_valid
    end
  end
end
