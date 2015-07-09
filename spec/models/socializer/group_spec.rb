require "rails_helper"

module Socializer
  RSpec.describe Group, type: :model do
    let(:group) { build(:socializer_group) }

    it "has a valid factory" do
      expect(group).to be_valid
    end

    context "mass assignment" do
      it { is_expected.to allow_mass_assignment_of(:display_name) }
      it { is_expected.to allow_mass_assignment_of(:privacy) }
      it { is_expected.to allow_mass_assignment_of(:author_id) }
    end

    context "relationships" do
      it do
        is_expected
        .to belong_to(:activity_author)
          .class_name("ActivityObject")
          .with_foreign_key("author_id")
          .inverse_of(:groups)
      end

      it do
        is_expected
        .to have_one(:author)
          .through(:activity_author)
          .source(:activitable)
      end

      it { is_expected.to have_many(:links) }
      it { is_expected.to have_many(:categories) }
      it { is_expected.to have_many(:memberships).inverse_of(:group) }

      it do
        is_expected
        .to have_many(:activity_members)
          .through(:memberships)
          .conditions(socializer_memberships: { active: true })
      end

      it do
        is_expected
        .to have_many(:members)
          .through(:activity_members)
          .source(:activitable)
      end
    end

    context "validations" do
      it { is_expected.to validate_presence_of(:activity_author) }
      it { is_expected.to validate_presence_of(:display_name) }
      it { is_expected.to validate_presence_of(:privacy) }
      it "check uniqueness of display_name" do
        create(:socializer_group)
        is_expected
        .to validate_uniqueness_of(:display_name)
          .scoped_to(:author_id)
          .case_insensitive
      end
    end

    it do
      is_expected
      .to enumerize(:privacy).in(:public, :restricted, :private)
        .with_default(:public)
    end

    it { is_expected.to respond_to(:author) }
    it { is_expected.to respond_to(:members) }
    it { is_expected.to respond_to(:join) }
    it { is_expected.to respond_to(:invite) }
    it { is_expected.to respond_to(:leave) }
    it { is_expected.to respond_to(:member?) }

    context "when group is public" do
      let(:public_group) { create(:socializer_group, privacy: :public) }
      let(:person) { create(:socializer_person) }

      let(:membership_attributes) do
        { member_id: person.guid, group_id: public_group.id }
      end

      before do
        public_group.save!
      end

      it ".public has 1 group" do
        expect(Socializer::Group.public.size).to eq(1)
      end

      it ".joinable has 1 group" do
        expect(Socializer::Group.joinable.size).to eq(1)
      end

      it "is has the right privacy level" do
        expect(public_group.privacy.public?).to be_truthy
      end

      it "member? is false" do
        expect(public_group.member?(person)).to be_falsey
      end

      context "and a person joins it" do
        before do
          public_group.join(person)
          @membership = Membership.find_by(membership_attributes)
        end

        it "creates an active membership" do
          expect(@membership.active).to be_truthy
        end

        it "member? is true" do
          expect(public_group.member?(person)).to be_truthy
        end

        # The factory adds a person to the public group by default
        it "has 2 members" do
          expect(public_group.members.size).to eq(2)
        end

        context "and leaving" do
          before do
            public_group.leave(person)
            @membership = Membership.find_by(membership_attributes)
          end

          it "destroys the membership" do
            expect(@membership).to be_nil
          end

          # The factory adds a person to the public group by default
          it "has 1 member" do
            expect(public_group.members.size).to eq(1)
          end
        end
      end
    end

    context "when group is restricted" do
      let(:restricted_group) do
        create(:socializer_group, privacy: :restricted)
      end

      let(:membership_attributes) do
        { member_id: person.guid, group_id: restricted_group.id }
      end

      let(:person) { create(:socializer_person) }

      before do
        restricted_group.save!
      end

      it ".restricted has 1 group" do
        expect(Socializer::Group.restricted.size).to eq(1)
      end

      it ".joinable has 1 group" do
        expect(Socializer::Group.joinable.size).to eq(1)
      end

      it "has the right privacy level" do
        expect(restricted_group.privacy.restricted?).to be_truthy
      end

      context "and a person joins it" do
        before do
          restricted_group.join(person)
          @membership = Membership.find_by(membership_attributes)
        end

        it "creates an inactive membership" do
          expect(@membership.active).to be_falsey
        end
      end
    end

    context "when group is private" do
      let(:private_group) { create(:socializer_group, privacy: :private) }
      let(:person) { create(:socializer_person) }

      let(:error_message) do
        I18n.t("socializer.errors.messages.group.private.cannot_self_join")
      end

      let(:membership_attributes) do
        { member_id: person.guid, group_id: private_group.id }
      end

      before do
        private_group.save!
      end

      it ".private has 1 group" do
        expect(Socializer::Group.private.size).to eq(1)
      end

      it "is has the right privacy level" do
        expect(private_group.privacy.private?).to be_truthy
      end

      it "cannot be joined" do
        expect { private_group.join(person) }
        .to raise_error(RuntimeError, error_message)
      end

      context "and a person gets invited" do
        before do
          private_group.invite(person)
          @membership = Membership.find_by(membership_attributes)
        end

        it "creates an inactive membership" do
          expect(@membership.active).to be_falsey
        end
      end
    end

    context "when inviting a person" do
      let(:group) { create(:socializer_group) }
      let(:person) { create(:socializer_person) }

      let(:membership_attributes) do
        { member_id: person.guid, group_id: group.id }
      end

      before do
        group.invite(person)
        @membership = Membership.find_by(membership_attributes)
      end

      it "creates an inactive membership" do
        expect(@membership.active).to be_falsey
      end
    end

    context "when having no member" do
      let(:group_without_members) do
        create(:socializer_group, privacy: :private)
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
        create(:socializer_group, privacy: :private)
      end

      context "cannot be deleted" do
        before do
          group_with_members.destroy
        end

        it { expect(group_with_members.destroyed?).to be false }
        it { expect(group_with_members.errors.present?).to be true }
        it { expect(group_with_members.memberships.count).to eq(1) }
      end
    end
  end
end
