require 'spec_helper'

module Socializer
  RSpec.describe Comment, type: :model do
    let(:comment) { build(:socializer_comment) }

    it 'has a valid factory' do
      expect(comment).to be_valid
    end

    it '#content' do
      expect(comment).to respond_to(:content)
    end

    it '#author' do
      expect(comment).to respond_to(:author)
    end
  end
end
