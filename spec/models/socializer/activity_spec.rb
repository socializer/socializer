require 'spec_helper'

module Socializer
  describe Activity do
    let(:activity) { build(:socializer_activity) }

    it 'has a valid factory' do
      expect(activity).to be_valid
    end

    it '#notifications' do
      expect(activity).to respond_to(:notifications)
    end

  end
end
