require 'spec_helper'

module Socializer
  describe ActivityObject do
    it 'has a valid factory' do
      expect(build(:socializer_activity_object)).to be_valid
    end
  end
end
