# frozen_string_literal: true

require "rails_helper"

module Socializer
  RSpec.describe Comment, type: :model do
    let(:comment) { build(:comment, content: "Comment") }

    it "has a valid factory" do
      expect(comment).to be_valid
    end

    context "with relationships" do
      specify do
        expect(comment).to belong_to(:activity_author)
          .class_name("ActivityObject")
          .with_foreign_key("author_id")
          .inverse_of(:comments)
      end

      specify do
        expect(comment).to have_one(:author)
          .through(:activity_author)
          .source(:activitable)
      end
    end

    context "with validations" do
      specify { is_expected.to validate_presence_of(:content) }
    end

    # TODO: Test return values
    specify { expect(comment.author).to be_a(Socializer::Person) }
    specify { expect(comment.content).to eq("Comment") }
  end
end
