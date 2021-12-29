# frozen_string_literal: true

require "rails_helper"

module Socializer
  RSpec.describe ActivityObject, type: :model do
    let(:activity_object) { build(:activity_object) }

    it "has a valid factory" do
      expect(activity_object).to be_valid
    end

    context "with relationships" do
      specify { is_expected.to belong_to(:activitable) }

      specify do
        expect(activity_object).to have_one(:self_reference)
          .class_name("ActivityObject")
          .with_foreign_key("id")
      end

      # FIXME: Test for source_type when available
      specify do
        expect(activity_object).to have_one(:group)
          .through(:self_reference)
          .source(:activitable)
      end

      # FIXME: Test for source_type when available
      specify do
        expect(activity_object).to have_one(:person)
          .through(:self_reference)
          .source(:activitable)
      end

      specify do
        expect(activity_object).to have_many(:notifications)
          .inverse_of(:activity_object)
      end

      specify do
        expect(activity_object).to have_many(:audiences)
          .inverse_of(:activity_object)
      end

      specify { is_expected.to have_many(:activities).through(:audiences) }
      specify { is_expected.to have_many(:actor_activities) }
      specify { is_expected.to have_many(:object_activities) }
      specify { is_expected.to have_many(:target_activities) }
      specify { is_expected.to have_many(:notes).inverse_of(:activity_author) }

      specify do
        expect(activity_object).to have_many(:comments)
          .inverse_of(:activity_author)
      end

      specify { is_expected.to have_many(:groups).inverse_of(:activity_author) }

      specify do
        expect(activity_object).to have_many(:circles)
          .inverse_of(:activity_author)
      end

      specify { is_expected.to have_many(:contacts).through(:circles) }
      specify { is_expected.to have_many(:ties).inverse_of(:activity_contact) }

      specify do
        expect(activity_object)
          .to have_many(:memberships)
          .conditions(active: true)
          .inverse_of(:activity_member)
      end
    end

    context "with validations" do
      specify { is_expected.to validate_presence_of(:activitable) }
    end

    context "with scopes" do
      describe "with_id" do
        let(:sql) { described_class.with_id(id: 1).to_sql }

        specify do
          expect(sql)
            .to include('WHERE "socializer_activity_objects"."id" = 1')
        end
      end

      describe "with_activitable_type" do
        let(:sql) do
          described_class.with_activitable_type(type: Comment.name).to_sql
        end

        let(:expected) do
          %q(
              WHERE "socializer_activity_objects"."activitable_type" =
                'Socializer::Comment'
            ).squish
        end

        specify do
          expect(sql).to include(expected)
        end
      end
    end

    specify { is_expected.to respond_to(:scope) }

    describe "check activitable_type predicates" do
      describe "#activity?" do
        let(:activity_object) { build(:activity_object_activity) }

        specify { expect(activity_object).to be_activity }
      end

      describe "#circle?" do
        let(:activity_object) { build(:activity_object_circle) }

        specify { expect(activity_object).to be_circle }
      end

      describe "#comment?" do
        let(:activity_object) { build(:activity_object_comment) }

        specify { expect(activity_object).to be_comment }
      end

      describe "#group?" do
        let(:activity_object) { build(:activity_object_group) }

        specify { expect(activity_object).to be_group }
      end

      describe "#note?" do
        let(:activity_object) { build(:activity_object) }

        specify { expect(activity_object).to be_note }
      end

      describe "#person?" do
        let(:activity_object) { build(:activity_object_person) }

        specify { expect(activity_object).to be_person }
      end
    end

    describe "#reset_unread_notifications" do
      let(:activity_object) do
        create(:activity_object, unread_notifications_count: 10)
      end

      before do
        activity_object.reset_unread_notifications
      end

      specify { expect(activity_object.unread_notifications_count).to eq(0) }
    end

    describe "#attribute_type_of" do
      it "when type is 'Activity" do
        activity_object.activitable_type = "Socializer::Activity"
        expect(activity_object.send(:activity?)).to be_truthy
      end

      it "when type is 'Circle" do
        activity_object.activitable_type = "Socializer::Circle"
        expect(activity_object.send(:circle?)).to be_truthy
      end

      it "when type is 'Comment" do
        activity_object.activitable_type = "Socializer::Comment"
        expect(activity_object.send(:comment?)).to be_truthy
      end

      it "when type is 'Group" do
        activity_object.activitable_type = "Socializer::Group"
        expect(activity_object.send(:group?)).to be_truthy
      end

      it "when type is 'Note" do
        activity_object.activitable_type = "Socializer::Note"
        expect(activity_object.send(:note?)).to be_truthy
      end

      it "when type is 'Person" do
        activity_object.activitable_type = "Socializer::Person"
        expect(activity_object.send(:person?)).to be_truthy
      end
    end
  end
end
