# frozen_string_literal: true

require "rails_helper"

module Socializer
  RSpec.describe ActivityObject, type: :model do
    let(:activity_object) { build(:activity_object) }

    it "has a valid factory" do
      expect(activity_object).to be_valid
    end

    context "relationships" do
      it { is_expected.to belong_to(:activitable) }

      it do
        is_expected.to have_one(:self_reference)
          .class_name("ActivityObject")
          .with_foreign_key("id")
      end

      # FIXME: Test for source_type when available
      it do
        is_expected.to have_one(:group)
          .through(:self_reference)
          .source(:activitable)
      end

      # FIXME: Test for source_type when available
      it do
        is_expected.to have_one(:person)
          .through(:self_reference)
          .source(:activitable)
      end

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
      context "with_id" do
        let(:sql) { ActivityObject.with_id(id: 1).to_sql }

        it do
          expect(sql)
            .to include('WHERE "socializer_activity_objects"."id" = 1')
        end
      end

      context "with_activitable_type" do
        let(:sql) do
          ActivityObject.with_activitable_type(type: Comment.name).to_sql
        end

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

        it { expect(activity_object).to be_person }
      end
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
