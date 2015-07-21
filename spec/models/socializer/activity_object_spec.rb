require "rails_helper"

module Socializer
  RSpec.describe ActivityObject, type: :model do
    let(:activity_object) { build(:activity_object) }

    it "has a valid factory" do
      expect(activity_object).to be_valid
    end

    context "mass assignment" do
      it { is_expected.to allow_mass_assignment_of(:scope) }
      it { is_expected.to allow_mass_assignment_of(:object_ids) }
      it { is_expected.to allow_mass_assignment_of(:activitable_id) }
      it { is_expected.to allow_mass_assignment_of(:activitable_type) }
      it { is_expected.to allow_mass_assignment_of(:like_count) }

      it do
        is_expected.to allow_mass_assignment_of(:unread_notifications_count)
      end

      it { is_expected.to allow_mass_assignment_of(:object_ids) }
    end

    context "relationships" do
      it { is_expected.to belong_to(:activitable) }

      it do
        is_expected.to have_many(:notifications).inverse_of(:activity_object)
      end

      it { is_expected.to have_many(:audiences).inverse_of(:activity_object) }
      it { is_expected.to have_many(:activities).through(:audiences) }
      it { is_expected.to have_many(:actor_activities) }
      it { is_expected.to have_many(:object_activities) }
      it { is_expected.to have_many(:target_activities) }
      it { is_expected.to have_many(:notes).inverse_of(:activity_author) }
      it { is_expected.to have_many(:comments).inverse_of(:activity_author) }
      it { is_expected.to have_many(:groups).inverse_of(:activity_author) }
      it { is_expected.to have_many(:circles).inverse_of(:activity_author) }
      it { is_expected.to have_many(:contacts).through(:circles) }
      it { is_expected.to have_many(:ties).inverse_of(:activity_contact) }

      it do
        is_expected
          .to have_many(:memberships)
          .conditions(active: true)
          .inverse_of(:activity_member)
      end
    end

    context "validations" do
      it { is_expected.to validate_presence_of(:activitable) }
    end

    context "scopes" do
      context "by_id" do
        let(:sql) { ActivityObject.by_id(1).to_sql }

        it do
          expect(sql)
            .to include('WHERE "socializer_activity_objects"."id" = 1')
        end
      end

      context "by_activitable_type" do
        let(:sql) { ActivityObject.by_activitable_type(Comment.name).to_sql }

        let(:expected) do
          %q(
              WHERE "socializer_activity_objects"."activitable_type" =
                'Socializer::Comment'
            ).squish
        end

        it do
          expect(sql).to include(expected)
        end
      end
    end

    context "when liked" do
      let(:liking_person) { create(:person) }
      let(:liked_activity_object) { create(:activity_object) }

      before do
        liked_activity_object.like(liking_person)
        liked_activity_object.reload
      end

      it { expect(liked_activity_object.like_count).to eq(1) }
      it { expect(liked_activity_object.liked_by.size).to eq(1) }

      context "and unliked" do
        before do
          liked_activity_object.unlike(liking_person)
          liked_activity_object.reload
        end

        it { expect(liked_activity_object.like_count).to eq(0) }
        it { expect(liked_activity_object.liked_by.size).to eq(0) }
      end
    end

    it { is_expected.to respond_to(:scope) }

    context "check activitable_type predicates" do
      context "#activity?" do
        let(:activity_object) { build(:activity_object_activity) }
        it { expect(activity_object.activity?).to be_truthy }
      end

      context "#circle?" do
        let(:activity_object) { build(:activity_object_circle) }
        it { expect(activity_object.circle?).to be_truthy }
      end

      context "#comment?" do
        let(:activity_object) { build(:activity_object_comment) }
        it { expect(activity_object.comment?).to be_truthy }
      end

      context "#group?" do
        let(:activity_object) { build(:activity_object_group) }
        it { expect(activity_object.group?).to be_truthy }
      end

      context "#note?" do
        let(:activity_object) { build(:activity_object) }
        it { expect(activity_object.note?).to be_truthy }
      end

      context "#person?" do
        let(:activity_object) { build(:activity_object_person) }
        it { expect(activity_object.person?).to be_truthy }
      end
    end

    context "when an object is liked" do
      let(:activity_object) { create(:activity_object) }
      let(:liking_person) { create(:person) }

      before do
        activity_object.like(liking_person)
        activity_object.reload
        liking_person.reload
      end

      it { expect(activity_object.like_count).to eq(1) }
      it { expect(activity_object.liked_by.size).to eq(1) }
      it { expect(liking_person.likes.count.size).to eq(1) }
      it { expect(liking_person.likes? activity_object).to be_truthy }

      context "when an object is unliked" do
        before do
          activity_object.unlike(liking_person)
          activity_object.reload
          liking_person.reload
        end

        it { expect(activity_object.like_count).to eq(0) }
        it { expect(activity_object.liked_by.size).to eq(0) }
        it { expect(liking_person.likes.count.size).to eq(0) }
        it { expect(liking_person.likes? activity_object).to be_falsey }
      end
    end

    context "when an object is shared" do
      let(:activity_object) { create(:activity_object) }
      let(:actor) { create(:person) }

      let(:object_ids) do
        Socializer::Audience.privacy.find_value(:public).value.split(",")
      end

      let(:share_attributes) do
        { actor_id: actor.guid, object_ids: object_ids, content: "Share" }
      end

      let(:results) { activity_object.share(share_attributes) }

      it { expect(results.persisted?).to eq(true) }
      it { expect(results.actor_id).to eq(actor.guid) }
      it { expect(results.activity_object_id).to eq(activity_object.id) }
      it { expect(results.verb.display_name).to eq("share") }
      it { expect(results.activity_field_content).to eq("Share") }

      context "with no content" do
        let(:share_attributes) do
          { actor_id: actor.guid, object_ids: object_ids, content: nil }
        end

        let(:results) { activity_object.share(share_attributes) }

        it { expect(results.activity_field_content).to eq(nil) }
      end
    end

    context "#increment_unread_notifications_count" do
      let(:activity_object) do
        create(:activity_object)
      end

      before do
        activity_object.increment_unread_notifications_count
        activity_object.reload
      end

      it { expect(activity_object.unread_notifications_count).to eq(1) }
    end

    context "#reset_unread_notifications" do
      let(:activity_object) do
        create(:activity_object, unread_notifications_count: 10)
      end

      before do
        activity_object.reset_unread_notifications
      end

      it { expect(activity_object.unread_notifications_count).to eq(0) }
    end

    context "#attribute_type_of" do
      it "when type is 'Activity" do
        activity_object.activitable_type = "Socializer::Activity"
        expect(activity_object.send("activity?")).to be_truthy
      end

      it "when type is 'Circle" do
        activity_object.activitable_type = "Socializer::Circle"
        expect(activity_object.send("circle?")).to be_truthy
      end

      it "when type is 'Comment" do
        activity_object.activitable_type = "Socializer::Comment"
        expect(activity_object.send("comment?")).to be_truthy
      end

      it "when type is 'Group" do
        activity_object.activitable_type = "Socializer::Group"
        expect(activity_object.send("group?")).to be_truthy
      end

      it "when type is 'Note" do
        activity_object.activitable_type = "Socializer::Note"
        expect(activity_object.send("note?")).to be_truthy
      end

      it "when type is 'Person" do
        activity_object.activitable_type = "Socializer::Person"
        expect(activity_object.send("person?")).to be_truthy
      end
    end
  end
end
