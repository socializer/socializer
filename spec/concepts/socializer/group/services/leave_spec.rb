require "rails_helper"

module Socializer
  class Group
    module Services
      RSpec.describe Leave, type: :service do
        let(:group) { build(:group) }
        let(:person) { build(:person) }

        describe "when the group and person arguments are nil" do
          context ".new should raise an ArgumentError" do
            let(:leave) { Leave.new(group: nil, person: nil) }
            it { expect { leave }.to raise_error(ArgumentError) }
          end
        end

        describe "when the group argument is nil" do
          context ".new should raise an ArgumentError" do
            let(:leave) { Leave.new(group: nil, person: person) }
            it { expect { leave }.to raise_error(ArgumentError) }
          end
        end

        describe "when the person argument is nil" do
          context ".new should raise an ArgumentError" do
            let(:leave) { Leave.new(group: group, person: nil) }
            it { expect { leave }.to raise_error(ArgumentError) }
          end
        end

        describe ".call" do
          let(:person) { create(:person) }

          let(:membership_attributes) do
            { member_id: person.guid, group_id: group.id }
          end

          before do
            group.join(person: person)
            Group::Services::Leave.new(group: group, person: person).call
            @membership = Membership.find_by(membership_attributes)
          end

          describe "when the group is public" do
            let(:group) { create(:group, privacy: :public) }

            it "it destroys the membership" do
              expect(@membership).to be_nil
            end

            it "it has 1 member" do
              expect(group.members.size).to eq(1)
            end
          end
        end
      end
    end
  end
end
