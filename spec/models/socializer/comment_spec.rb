require 'rails_helper'

module Socializer
  RSpec.describe Comment, type: :model do
    let(:comment) { build(:socializer_comment, content: 'Comment') }

    it 'has a valid factory' do
      expect(comment).to be_valid
    end

    context 'mass assignment' do
      it { is_expected.to allow_mass_assignment_of(:content) }
    end

    context 'relationships' do
      it { is_expected.to belong_to(:activity_author) }
    end

    # TODO: Test return values
    it { expect(comment.author).to be_kind_of(Socializer::Person) }
    it { expect(comment.content).to eq('Comment') }
  end
end
