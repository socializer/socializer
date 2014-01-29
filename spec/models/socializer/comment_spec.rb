require 'spec_helper'

module Socializer
  describe Comment do
    it 'has a valid factory' do
      expect(build(:socializer_comment)).to be_valid
    end
  end
end
