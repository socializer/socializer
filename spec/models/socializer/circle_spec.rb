# frozen_string_literal: true

require "rails_helper"

module Socializer
  RSpec.describe Circle do
    let(:circle) { build(:circle) }

    it "has a valid factory" do
      expect(circle).to be_valid
    end

    context "with relationships" do
      specify do
        expect(circle).to belong_to(:activity_author)
          .class_name("ActivityObject")
          .with_foreign_key("author_id")
          .inverse_of(:circles)
      end

      specify do
        expect(circle).to have_one(:author)
          .through(:activity_author)
          .source(:activitable)
      end

      specify { is_expected.to have_many(:ties).inverse_of(:circle) }
      specify { is_expected.to have_many(:activity_contacts).through(:ties) }

      specify do
        expect(circle)
          .to have_many(:contacts)
          .through(:activity_contacts)
          .source(:activitable)
      end
    end

    context "with validations" do
      specify { is_expected.to validate_presence_of(:display_name) }

      it "check uniqueness of display_name" do
        create(:circle)
        expect(circle)
          .to validate_uniqueness_of(:display_name)
          .scoped_to(:author_id)
          .case_insensitive
      end
    end

    context "with scopes" do
      describe "with_id" do
        let(:sql) { described_class.with_id(id: 1).to_sql }

        specify do
          expect(sql).to include('WHERE "socializer_circles"."id" = 1')
        end
      end

      describe "with_author_id" do
        let(:sql) { described_class.with_author_id(id: 1).to_sql }

        specify do
          expect(sql).to include('WHERE "socializer_circles"."author_id" = 1')
        end
      end

      describe "with_display_name" do
        let(:sql) { described_class.with_display_name(name: "Friends").to_sql }

        let(:expected) do
          %q(WHERE "socializer_circles"."display_name" = 'Friends')
        end

        specify do
          expect(sql).to include(expected)
        end
      end
    end

    describe "author" do
      # TODO: Test return values
      specify { expect(circle.author).to be_a(Socializer::Person) }
    end

    context "when adding a contact" do
      let(:circle_with_contacts) { create(:circle) }

      before do
        circle_with_contacts.add_contact(1)
        circle_with_contacts.reload
      end

      specify { expect(circle_with_contacts.ties.size).to be(1) }
      specify { expect(circle_with_contacts.contacts.size).to be(1) }

      describe "and removing it" do
        before do
          circle_with_contacts.remove_contact(1)
          circle_with_contacts.reload
        end

        specify { expect(circle_with_contacts.ties.size).to be(0) }
        specify { expect(circle_with_contacts.contacts.size).to be(0) }
      end
    end

    specify { is_expected.to respond_to(:author) }
  end
end
