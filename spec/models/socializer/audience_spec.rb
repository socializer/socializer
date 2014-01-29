require 'spec_helper'

module Socializer
  describe Audience do
    it { should enumerize(:privacy_level).in(:public, :circles, :limited).with_default(:public) }

    it 'has a valid factory' do
      expect(build(:socializer_audience)).to be_valid
    end

    it 'is invalid without a privacy level' do
      expect(build(:socializer_audience, privacy_level: nil)).to be_invalid
    end

    it '#activity' do
      expect(build(:socializer_audience)).to respond_to(:activity)
    end

    it '#activity_object' do
      expect(build(:socializer_audience)).to respond_to(:activity_object)
    end

    it '#object' do
      expect(build(:socializer_audience)).to respond_to(:object)
    end
  end
end
