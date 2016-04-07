require "rails_helper"

module Socializer
  class Group
    module Services
      RSpec.describe Invite, type: :service do
        let(:person) { build(:person) }

        describe ".call" do
          let(:person) { create(:person) }

          let(:membership_attributes) do
            { member_id: person.guid, group_id: group.id }
          end

          before do
            Group::Services::Invite.new(group: group, person: person).call
            @membership = Membership.find_by(membership_attributes)
          end

          describe "when the group is public" do
            let(:public_group) { create(:group, privacy: :public) }
            let(:group) { public_group }

            it { expect(public_group.memberships.size).to eq(2) }

            it "creates an inactive membership" do
              expect(@membership.active).to be_falsey
            end
          end

          describe "when the group is private" do
            let(:private_group) { create(:group, privacy: :private) }
            let(:group) { private_group }

            it { expect(private_group.memberships.size).to eq(2) }

            it "creates an inactive membership" do
              expect(@membership.active).to be_falsey
            end
          end
        end
      end
    end
  end
end
