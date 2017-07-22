# frozen_string_literal: true

require "rails_helper"

module Socializer
  RSpec.describe Circle, type: :model do
    let(:circle) { build(:circle) }

    it "has a valid factory" do
      expect(circle).to be_valid
    end

    context "relationships" do
      it do
        is_expected
          .to belong_to(:activity_author)
          .class_name("ActivityObject")
          .with_foreign_key("author_id")
          .inverse_of(:circles)
      end

      it do
        is_expected
          .to have_one(:author)
          .through(:activity_author)
          .source(:activitable)
      end

      it { is_expected.to have_many(:ties).inverse_of(:circle) }
      it { is_expected.to have_many(:activity_contacts).through(:ties) }

      it do
        is_expected
          .to have_many(:contacts)
          .through(:activity_contacts)
          .source(:activitable)
      end
    end

    context "validations" do
      it { is_expected.to validate_presence_of(:activity_author) }
      it { is_expected.to validate_presence_of(:display_name) }

      it "check uniqueness of display_name" do
        create(:circle)
        is_expected
          .to validate_uniqueness_of(:display_name)
          .scoped_to(:author_id)
          .case_insensitive
      end
    end

    context "scopes" do
      context "with_id" do
        let(:sql) { Circle.with_id(id: 1).to_sql }

        it { expect(sql).to include('WHERE "socializer_circles"."id" = 1') }
      end

      context "with_author_id" do
        let(:sql) { Circle.with_author_id(id: 1).to_sql }

        it do
          expect(sql).to include('WHERE "socializer_circles"."author_id" = 1')
        end
      end

      context "with_display_name" do
        let(:sql) { Circle.with_display_name(name: "Friends").to_sql }

        let(:expected) do
          %q(WHERE "socializer_circles"."display_name" = 'Friends')
        end

        it do
          expect(sql).to include(expected)
        end
      end
    end

    context "author" do
      # TODO: Test return values
      it { expect(circle.author).to be_kind_of(Socializer::Person) }
    end

    context "when adding a contact" do
      let(:circle_with_contacts) { create(:circle) }

      before do
        circle_with_contacts.add_contact(1)
        circle_with_contacts.reload
      end

      it { expect(circle_with_contacts.ties.size).to be(1) }
      it { expect(circle_with_contacts.contacts.size).to be(1) }

      context "and removing it" do
        before do
          circle_with_contacts.remove_contact(1)
          circle_with_contacts.reload
        end

        it { expect(circle_with_contacts.ties.size).to be(0) }
        it { expect(circle_with_contacts.contacts.size).to be(0) }
      end
    end

    it { is_expected.to respond_to(:author) }
  end
end
