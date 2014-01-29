require 'spec_helper'

module Socializer
  describe Authentication do
    it 'has a valid factory' do
      expect(build(:socializer_authentication)).to be_valid
    end
  end
end
