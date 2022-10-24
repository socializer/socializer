# frozen_string_literal: true

require "rails_helper"

module Socializer
  RSpec.describe Activity do
    let(:activity) { build(:activity) }

    it "has a valid factory" do
      expect(activity).to be_valid
    end

    context "with relationships" do
      specify { is_expected.to belong_to(:parent).optional }
      specify { is_expected.to belong_to(:activitable_target).optional }
      specify { is_expected.to belong_to(:verb).inverse_of(:activities) }

      specify do
        expect(activity).to belong_to(:activitable_actor)
          .class_name("ActivityObject")
          .with_foreign_key("actor_id")
          .inverse_of(:actor_activities)
      end

      specify do
        expect(activity).to belong_to(:activitable_object)
          .class_name("ActivityObject")
          .with_foreign_key("activity_object_id")
          .inverse_of(:object_activities)
      end

      specify do
        expect(activity)
          .to have_one(:actor).through(:activitable_actor).source(:activitable)
      end

      specify { is_expected.to have_one(:activity_field) }
      specify { is_expected.to have_many(:audiences).inverse_of(:activity) }
      specify { is_expected.to have_many(:activity_objects) }
      specify { is_expected.to have_many(:children) }
      specify { is_expected.to have_many(:notifications).inverse_of(:activity) }
    end

    # context "with validations" do
    # end

    context "with scopes" do
      describe "newest_first" do
        let(:sql) { described_class.newest_first.to_sql }

        specify do
          expect(sql)
            .to include('ORDER BY "socializer_activities"."created_at" DESC')
        end
      end

      describe "with_id" do
        let(:sql) { described_class.with_id(id: 1).to_sql }

        specify do
          expect(sql).to include('WHERE "socializer_activities"."id" = 1')
        end
      end

      describe "with_activity_object_id" do
        let(:sql) { described_class.with_activity_object_id(id: 1).to_sql }

        let(:expected) do
          'WHERE "socializer_activities"."activity_object_id" = 1'
        end

        specify do
          expect(sql).to include(expected)
        end
      end

      describe "with_actor_id" do
        let(:sql) { described_class.with_actor_id(id: 1).to_sql }

        specify do
          expect(sql)
            .to include('WHERE "socializer_activities"."actor_id" = 1')
        end
      end

      describe "with_target_id" do
        let(:sql) { described_class.with_target_id(id: 1).to_sql }

        specify do
          expect(sql)
            .to include('WHERE "socializer_activities"."target_id" = 1')
        end
      end
    end

    specify do
      expect(activity)
        .to delegate_method(:activity_field_content)
        .to(:activity_field)
        .as(:content)
    end

    specify do
      expect(activity)
        .to delegate_method(:verb_display_name)
        .to(:verb)
        .as(:display_name)
    end

    describe "#comments" do
      specify { expect(activity.comments?).to be(false) }

      describe "expected to be true" do
        let(:activity) { create(:activity) }
        let(:scope) { Audience.privacy.find_value(:public) }

        let(:comment_attributes) do
          { content: "Comment",
            activity_target_id: activity.id,
            activity_verb: "add",
            scope: }
        end

        let(:actor) { activity.actor }

        before do
          actor.comments.create!(comment_attributes)
        end

        specify { expect(activity.comments?).to be(true) }
      end
    end

    # TODO: Test return values
    specify { expect(activity.actor).to be_a(Socializer::Person) }
    specify { expect(activity.object).to be_a(Socializer::Note) }
    specify { expect(activity.target).to be_a(Socializer::Group) }

    describe ".stream" do
      let(:activity_object_person) do
        build(:activity_object_person)
      end

      let(:activity_object_group) { build(:activity_object_group) }
      let(:person) { activity_object_person.activitable }
      let(:group) { activity_object_group.activitable }

      # TODO: Test return values
      specify do
        expect { described_class.stream }.to raise_error(ArgumentError)
      end

      specify do
        expect(described_class.stream(viewer_id: person.id))
          .to be_a(ActiveRecord::Relation)
      end

      specify do
        expect(described_class
                 .activity_stream(actor_uid: person.id, viewer_id: person.id))
          .to be_a(ActiveRecord::Relation)
      end

      specify do
        expect(described_class
                 .circle_stream(actor_uid: person.id, viewer_id: person.id))
          .to be_a(ActiveRecord::Relation)
      end

      specify do
        expect(described_class
                 .group_stream(actor_uid: group.id, viewer_id: person.id))
          .to be_a(ActiveRecord::Relation)
      end

      specify do
        expect(described_class
                 .person_stream(actor_uid: person.id, viewer_id: person.id))
          .to be_a(ActiveRecord::Relation)
      end
    end
  end
end
