# frozen_string_literal: true

require "rails_helper"

module Socializer
  RSpec.describe Group do
    let(:group) { build(:group) }

    it "has a valid factory" do
      expect(group).to be_valid
    end

    context "with relationships" do
      specify do
        expect(group).to belong_to(:activity_author)
          .class_name("ActivityObject")
          .with_foreign_key("author_id")
          .inverse_of(:groups)
      end

      specify do
        expect(group).to have_one(:author)
          .through(:activity_author)
          .source(:activitable)
      end

      specify { is_expected.to have_many(:links) }
      specify { is_expected.to have_many(:categories) }
      specify { is_expected.to have_many(:memberships) }

      specify do
        expect(group)
          .to have_many(:activity_members)
          .through(:memberships)
          .conditions(socializer_memberships: { active: true })
      end

      specify do
        expect(group)
          .to have_many(:members)
          .through(:activity_members)
          .source(:activitable)
      end
    end

    context "with validations" do
      specify { is_expected.to validate_presence_of(:display_name) }
      specify { is_expected.to validate_presence_of(:privacy) }

      it "check uniqueness of display_name" do
        create(:group)
        expect(group)
          .to validate_uniqueness_of(:display_name)
          .scoped_to(:author_id)
          .case_insensitive
      end
    end

    context "with scopes" do
      describe "with_display_name" do
        let(:sql) { described_class.with_display_name(name: "Group").to_sql }

        let(:expected) do
          %q(WHERE "socializer_groups"."display_name" = 'Group')
        end

        specify do
          expect(sql).to include(expected)
        end
      end
    end

    specify do
      expect(group)
        .to enumerize(:privacy)
        .in(:public, :restricted, :private).with_default(:public)
        .with_predicates(true)
        .with_scope(true)
    end

    specify { is_expected.to respond_to(:author) }
    specify { is_expected.to respond_to(:members) }

    context "when having no member" do
      let(:group_without_members) do
        create(:group, privacy: :private)
      end

      before do
        # the author is added as a member, so remove it first
        group_without_members.memberships.first.destroy
      end

      it "can be deleted" do
        expect(group_without_members.destroy.destroyed?).to be true
      end
    end

    context "when having at least one member" do
      let(:group_with_members) do
        create(:group, privacy: :private)
      end

      describe "it cannot be deleted" do
        before do
          group_with_members.destroy
        end

        specify { expect(group_with_members.destroyed?).to be false }
        specify { expect(group_with_members.errors.present?).to be true }
        specify { expect(group_with_members.memberships.count).to eq(1) }
      end
    end
  end
end
