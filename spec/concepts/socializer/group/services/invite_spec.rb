# frozen_string_literal: true

require "rails_helper"

module Socializer
  RSpec.describe Group::Services::Invite do
    let(:person) { build(:person) }

    describe ".call" do
      let(:person) { create(:person) }

      let(:membership_attributes) do
        { member_id: person.guid, group_id: group.id }
      end

      let(:membership) { Membership.find_by(membership_attributes) }

      before do
        described_class.new(group:, person:).call
      end

      describe "when the group is public" do
        let(:public_group) { create(:group, privacy: :public) }
        let(:group) { public_group }

        it { expect(public_group.memberships.size).to eq(2) }

        it "creates an inactive membership" do
          expect(membership.active).to be_falsey
        end
      end

      describe "when the group is private" do
        let(:private_group) { create(:group, privacy: :private) }
        let(:group) { private_group }

        it { expect(private_group.memberships.size).to eq(2) }

        it "creates an inactive membership" do
          expect(membership.active).to be_falsey
        end
      end
    end
  end
end
