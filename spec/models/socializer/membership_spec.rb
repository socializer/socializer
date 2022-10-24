# frozen_string_literal: true

require "rails_helper"

module Socializer
  RSpec.describe Membership do
    let(:user) { create(:person) }

    let(:group) do
      create(:group, activity_author: user.activity_object)
    end

    let(:membership) do
      create(:socializer_membership,
             activity_member: user.activity_object,
             group:)
    end

    it "has a valid factory" do
      expect(membership).to be_valid
    end

    describe "relationships" do
      specify { is_expected.to belong_to(:group).inverse_of(:memberships) }

      specify do
        expect(membership)
          .to belong_to(:activity_member)
          .class_name("ActivityObject")
          .with_foreign_key("member_id")
          .inverse_of(:memberships)
      end

      specify do
        expect(membership)
          .to have_one(:member).through(:activity_member).source(:activitable)
      end
    end

    context "with scopes" do
      describe "active" do
        context "when no active records" do
          let(:result) { described_class.active }

          specify { expect(result).to be_a(ActiveRecord::Relation) }
          specify { expect(result.exists?).to be false }
        end

        context "with active records" do
          before { create(:socializer_membership, active: true) }

          let(:result) { described_class.active }

          specify { expect(result).to be_a(ActiveRecord::Relation) }
          specify { expect(result.first.active).to be true }
        end
      end

      describe "inactive" do
        context "when no inactive records" do
          let(:result) { described_class.inactive }

          specify { expect(result).to be_a(ActiveRecord::Relation) }
          specify { expect(result.exists?).to be false }
        end

        context "with inactive records" do
          before { create(:socializer_membership, active: false) }

          let(:result) { described_class.inactive }

          specify { expect(result).to be_a(ActiveRecord::Relation) }
          specify { expect(result.first.active).to be false }
        end
      end

      describe "with_member_id" do
        let(:sql) { described_class.with_member_id(member_id: 1).to_sql }

        specify do
          expect(sql)
            .to include('WHERE "socializer_memberships"."member_id" = 1')
        end

        context "when person has no memberships" do
          let(:user) { create(:person) }
          let(:result) { described_class.with_member_id(member_id: user.guid) }

          specify { expect(result).to be_a(ActiveRecord::Relation) }
          specify { expect(result.exists?).to be false }
        end

        context "when person has memberships" do
          let(:result) { described_class.with_member_id(member_id: user.guid) }

          before do
            membership
          end

          specify { expect(result).to be_a(ActiveRecord::Relation) }

          context "when they have memberships" do
            specify { expect(result.exists?).to be true }
            specify { expect(result.first.group_id).to eq group.id }
            specify { expect(result.first.member_id).to eq user.guid }
          end
        end
      end
    end

    describe "#member" do
      specify { expect(membership.member).to eq(user) }
    end

    describe "#confirm" do
      let(:inactive_membership) do
        create(:socializer_membership, active: false)
      end

      it "becomes active" do
        inactive_membership.confirm
        expect(inactive_membership.active).to be_truthy
      end
    end
  end
end
