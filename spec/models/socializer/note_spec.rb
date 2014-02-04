require 'spec_helper'

module Socializer
  describe Note do
    let(:note) { build(:socializer_note) }

    it 'has a valid factory' do
      expect(note).to be_valid
    end

    it '#content' do
      expect(note).to respond_to(:content)
    end

    it '#author' do
      expect(note).to respond_to(:author)
    end
  end
end
