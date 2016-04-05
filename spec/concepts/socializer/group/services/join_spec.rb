require "rails_helper"

module Socializer
  class Group
    module Services
      RSpec.describe Join, type: :service do
        let(:group) { build(:group) }
        let(:person) { build(:person) }

        describe ".call" do
          let(:person) { create(:person) }

          let(:membership_attributes) do
            { member_id: person.guid, group_id: group.id }
          end

          describe "when the group is public" do
            let(:group) { create(:group, privacy: :public) }

            before do
              group
            end

            it ".public has 1 group" do
              expect(Socializer::Group.public.size).to eq(1)
            end

            it ".joinable has 1 group" do
              expect(Socializer::Group.joinable.size).to eq(1)
            end

            it "is has the right privacy level" do
              expect(group.privacy.public?).to be_truthy
            end

            it "member? is false" do
              expect(group.member?(person)).to be_falsey
            end

            context "and a person joins it" do
              before do
                Group::Services::Join.new(group: group, person: person).call
                @membership = Membership.find_by(membership_attributes)
              end

              it "creates an active membership" do
                expect(@membership.active).to be_truthy
              end

              it "member? is true" do
                expect(group.member?(person)).to be_truthy
              end

              # The factory adds a person to the public group by default
              it "has 2 members" do
                expect(group.members.size).to eq(2)
              end
            end
          end

          describe "when the group is private" do
            let(:group) { create(:group, privacy: :private) }
            let(:error) { Errors::PrivateGroupCannotSelfJoin }

            let(:join) do
              Group::Services::Join.new(group: group, person: person)
            end

            let(:error_message) do
              I18n.t("private.cannot_self_join",
                     scope: "socializer.errors.messages.group")
            end

            before do
              group
            end

            it ".private has 1 group" do
              expect(Socializer::Group.private.size).to eq(1)
            end

            it "is has the right privacy level" do
              expect(group.privacy.private?).to be_truthy
            end

            it "cannot be joined" do
              expect { join.call }.to raise_error(error, error_message)
            end
          end

          describe "when the group is restricted" do
            let(:group) { create(:group, privacy: :restricted) }

            before do
              group
            end

            it ".restricted has 1 group" do
              expect(Socializer::Group.restricted.size).to eq(1)
            end

            it ".joinable has 1 group" do
              expect(Socializer::Group.joinable.size).to eq(1)
            end

            it "has the right privacy level" do
              expect(group.privacy.restricted?).to be_truthy
            end

            context "and a person joins it" do
              before do
                Group::Services::Join.new(group: group, person: person).call
                @membership = Membership.find_by(membership_attributes)
              end

              it "creates an inactive membership" do
                expect(@membership.active).to be_falsey
              end
            end
          end
        end
      end
    end
  end
end
