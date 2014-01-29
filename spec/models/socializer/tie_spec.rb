require 'spec_helper'

module Socializer
  describe Tie do
    let(:tie) { build(:socializer_tie) }

    it 'has a valid factory' do
      expect(tie).to be_valid
    end

    it '#circle' do
      expect(tie).to respond_to(:circle)
    end

    it '#contact' do
      expect(tie).to respond_to(:contact)
    end
  end
end
