# frozen_string_literal: true

require "rails_helper"

module Socializer
  RSpec.describe Note, type: :model do
    let(:note) { build(:note) }

    it "has a valid factory" do
      expect(note).to be_valid
    end

    context "relationships" do
      it do
        is_expected
          .to belong_to(:activity_author)
          .class_name("ActivityObject")
          .with_foreign_key("author_id")
          .inverse_of(:notes)
      end

      it do
        is_expected
          .to have_one(:author)
          .through(:activity_author)
          .source(:activitable)
      end
    end

    context "validations" do
      it { is_expected.to validate_presence_of(:activity_author) }
      it { is_expected.to validate_presence_of(:content) }
    end

    # TODO: Test return values
    it { expect(note.author).to be_kind_of(Socializer::Person) }
  end
end
