# frozen_string_literal: true

require "rails_helper"

module Socializer
  RSpec.describe Tie, type: :model do
    let(:contact) { create(:person) }
    let(:tie) { build(:tie, contact_id: contact.id) }

    it "has a valid factory" do
      expect(tie).to be_valid
    end

    context "with relationships" do
      specify { is_expected.to belong_to(:circle).inverse_of(:ties) }

      specify do
        expect(tie).to belong_to(:activity_contact)
          .class_name("ActivityObject")
          .with_foreign_key("contact_id")
          .inverse_of(:ties)
      end

      specify do
        expect(tie).to have_one(:contact)
          .through(:activity_contact)
          .source(:activitable)
      end
    end

    # context "with validations" do
    # end

    context "with scopes" do
      describe "with_circle_id" do
        let(:sql) { described_class.with_circle_id(circle_id: 1).to_sql }

        specify do
          expect(sql).to include('WHERE "socializer_ties"."circle_id" = 1')
        end
      end

      describe "with_contact_id" do
        let(:sql) { described_class.with_contact_id(contact_id: 1).to_sql }

        specify do
          expect(sql).to include('WHERE "socializer_ties"."contact_id" = 1')
        end

        specify { expect(tie.contact_id).to eq(contact.id) }

        context "when nil" do
          let(:tie) { build(:tie, contact_id: nil) }

          specify { expect(tie.contact_id).to be_nil }
        end
      end
    end

    # TODO: Test return values
    specify { expect(tie.contact).to be_kind_of(Socializer::Person) }
  end
end
