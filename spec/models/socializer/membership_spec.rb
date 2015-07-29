require "rails_helper"

module Socializer
  RSpec.describe Membership, type: :model do
    let(:user) { create(:person) }

    let(:group) do
      create(:group, activity_author: user.activity_object)
    end

    let(:membership) do
      create(
        :socializer_membership,
        activity_member: user.activity_object,
        group: group)
    end

    it "has a valid factory" do
      expect(membership).to be_valid
    end

    describe "mass assignment" do
      it { is_expected.to allow_mass_assignment_of(:group_id) }
      it { is_expected.to allow_mass_assignment_of(:active) }
      it { is_expected.to allow_mass_assignment_of(:activity_member) }
    end

    describe "relationships" do
      it { is_expected.to belong_to(:group).inverse_of(:memberships) }

      it do
        is_expected
          .to belong_to(:activity_member)
          .class_name("ActivityObject")
          .with_foreign_key("member_id")
          .inverse_of(:memberships)
      end

      it do
        is_expected
          .to have_one(:member).through(:activity_member).source(:activitable)
      end
    end

    describe "scopes" do
      context "active" do
        context "no active records" do
          let(:result) { Membership.active }

          it { expect(result).to be_kind_of(ActiveRecord::Relation) }
          it { expect(result.present?).to be false }
        end

        context "active records" do
          before { create(:socializer_membership, active: true) }
          let(:result) { Membership.active }

          it { expect(result).to be_kind_of(ActiveRecord::Relation) }
          it { expect(result.first.active).to be true }
        end
      end

      context "inactive" do
        context "no inactive records" do
          let(:result) { Membership.inactive }

          it { expect(result).to be_kind_of(ActiveRecord::Relation) }
          it { expect(result.present?).to be false }
        end

        context "inactive records" do
          before { create(:socializer_membership, active: false) }
          let(:result) { Membership.inactive }

          it { expect(result).to be_kind_of(ActiveRecord::Relation) }
          it { expect(result.first.active).to be false }
        end
      end

      context "with_member_id" do
        let(:sql) { Membership.with_member_id(member_id: 1).to_sql }

        it do
          expect(sql)
            .to include('WHERE "socializer_memberships"."member_id" = 1')
        end

        context "person has no memberships" do
          let(:user) { create(:person) }
          let(:result) { Membership.with_member_id(member_id: user.guid) }

          it { expect(result).to be_kind_of(ActiveRecord::Relation) }
          it { expect(result.present?).to be false }
        end

        context "person has memberships" do
          let(:result) { Membership.with_member_id(member_id: user.guid) }

          before do
            membership
          end

          it { expect(result).to be_kind_of(ActiveRecord::Relation) }

          it "has memberships" do
            expect(result.present?).to be true
            expect(result.first.group_id).to eq group.id
            expect(result.first.member_id).to eq user.guid
          end
        end
      end
    end

    describe "#member" do
      it { expect(membership.member).to eq(user) }
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
