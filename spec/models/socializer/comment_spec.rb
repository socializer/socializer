# frozen_string_literal: true

require "rails_helper"

module Socializer
  RSpec.describe Comment, type: :model do
    let(:comment) { build(:comment, content: "Comment") }

    it "has a valid factory" do
      expect(comment).to be_valid
    end

    context "mass assignment" do
      it { is_expected.to allow_mass_assignment_of(:content) }
    end

    context "relationships" do
      it do
        is_expected
          .to belong_to(:activity_author)
          .class_name("ActivityObject")
          .with_foreign_key("author_id")
          .inverse_of(:comments)
      end

      it do
        is_expected
          .to have_one(:author).through(:activity_author).source(:activitable)
      end
    end

    context "validations" do
      it { is_expected.to validate_presence_of(:activity_author) }
      it { is_expected.to validate_presence_of(:content) }
    end

    # TODO: Test return values
    it { expect(comment.author).to be_kind_of(Socializer::Person) }
    it { expect(comment.content).to eq("Comment") }
  end
end
