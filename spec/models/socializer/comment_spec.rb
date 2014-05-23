require 'spec_helper'

module Socializer
  RSpec.describe Comment, type: :model do
    let(:comment) { build(:socializer_comment) }

    it 'has a valid factory' do
      expect(comment).to be_valid
    end

    it { is_expected.to respond_to(:content) }
    it { is_expected.to respond_to(:author) }
  end
end
