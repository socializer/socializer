require 'spec_helper'

module Socializer
  describe Activity do
    let(:activity) { build(:socializer_activity) }

    it 'has a valid factory' do
      expect(activity).to be_valid
    end
  end
end
