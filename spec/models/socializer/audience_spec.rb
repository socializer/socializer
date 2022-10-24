# frozen_string_literal: true

require "rails_helper"

module Socializer
  RSpec.describe Audience do
    let(:audience) { build(:audience) }

    it "has a valid factory" do
      expect(audience).to be_valid
    end

    context "with relationships" do
      specify { is_expected.to belong_to(:activity).inverse_of(:audiences) }

      specify do
        expect(audience)
          .to belong_to(:activity_object).optional.inverse_of(:audiences)
      end
    end

    context "with validations" do
      specify { is_expected.to validate_presence_of(:privacy) }
      # specify { is_expected.to validate_presence_of(:activity_id) }
      #
      # specify do
      #   is_expected
      #   .to validate_uniqueness_of(:activity_id)
      #     .scoped_to(:activity_object_id)
      # end

      # specify do
      #   expect(create(:audience))
      #   .to validate_uniqueness_of(:activity_id)
      #     .scoped_to(:activity_object_id)
      # end
    end

    context "with scopes" do
      describe "with_activity_id" do
        let(:sql) { described_class.with_activity_id(id: 1).to_sql }

        specify do
          expect(sql)
            .to include('WHERE "socializer_audiences"."activity_id" = 1')
        end
      end

      describe "with_activity_object_id" do
        let(:sql) { described_class.with_activity_object_id(id: 1).to_sql }

        specify do
          expect(sql)
            .to include('WHERE "socializer_audiences"."activity_object_id" = 1')
        end
      end
    end

    specify do
      expect(audience).to enumerize(:privacy)
        .in(:public, :circles, :limited)
        .with_default(:public)
        .with_predicates(true)
        .with_scope(true)
    end

    describe "#object" do
      let(:activitable) { audience.activity_object.activitable }

      specify { expect(audience.object).to be_a(activitable.class) }
      specify { expect(audience.object).to eq(activitable) }
    end
  end
end
