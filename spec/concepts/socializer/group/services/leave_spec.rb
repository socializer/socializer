# frozen_string_literal: true

require "rails_helper"

module Socializer
  class Group
    module Services
      RSpec.describe Leave, type: :service do
        let(:person) { build(:person) }

        describe ".call" do
          let(:person) { create(:person) }

          let(:membership_attributes) do
            { member_id: person.guid, group_id: group.id }
          end

          let(:membership) { Membership.find_by(membership_attributes) }

          before do
            Group::Services::Join.new(group: group, person: person).call
            Group::Services::Leave.new(group: group, person: person).call
          end

          describe "when the group is public" do
            let(:public_group) { create(:group, privacy: :public) }
            let(:group) { public_group }

            it "destroys the membership" do
              expect(membership).to be_nil
            end

            it "has 1 member" do
              expect(public_group.members.size).to eq(1)
            end
          end
        end
      end
    end
  end
end
