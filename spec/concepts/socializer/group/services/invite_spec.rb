require "rails_helper"

module Socializer
  class Group
    module Services
      RSpec.describe Invite, type: :service do
        let(:group) { build(:group) }
        let(:person) { build(:person) }

        describe "when the group and person arguments are nil" do
          context ".new should raise an ArgumentError" do
            let(:invite) { Invite.new(group: nil, person: nil) }
            it { expect { invite }.to raise_error(ArgumentError) }
          end
        end

        describe "when the group argument is nil" do
          context ".new should raise an ArgumentError" do
            let(:invite) { Invite.new(group: nil, person: person) }
            it { expect { invite }.to raise_error(ArgumentError) }
          end
        end

        describe "when the person argument is nil" do
          context ".new should raise an ArgumentError" do
            let(:invite) { Invite.new(group: group, person: nil) }
            it { expect { invite }.to raise_error(ArgumentError) }
          end
        end

        describe ".call" do
          let(:person) { create(:person) }

          let(:membership_attributes) do
            { member_id: person.guid, group_id: group.id }
          end

          before do
            Group::Services::Invite.new(group: group, person: person).call
            @membership = Membership.find_by(membership_attributes)
          end

          describe "when the group is private" do
            let(:group) { create(:group, privacy: :private) }

            it { expect(group.memberships.size).to eq(2) }

            it "creates an inactive membership" do
              expect(@membership.active).to be_falsey
            end
          end

          describe "when the group is public" do
            let(:group) { create(:group, privacy: :public) }

            it { expect(group.memberships.size).to eq(2) }

            it "creates an inactive membership" do
              expect(@membership.active).to be_falsey
            end
          end
        end
      end
    end
  end
end
