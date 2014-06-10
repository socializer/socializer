require 'rails_helper'

module Socializer
  RSpec.describe Comment, type: :model do
    let(:comment) { build(:socializer_comment) }

    it 'has a valid factory' do
      expect(comment).to be_valid
    end

    it { is_expected.to respond_to(:content) }
    it { is_expected.to respond_to(:author) }

    # TODO: Test return values
    it { expect(comment.author).to be_kind_of(Socializer::Person) }
  end
end
