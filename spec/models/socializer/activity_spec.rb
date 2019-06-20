# frozen_string_literal: true

require "rails_helper"

module Socializer
  RSpec.describe Activity, type: :model do
    let(:activity) { build(:activity) }

    it "has a valid factory" do
      expect(activity).to be_valid
    end

    context "with relationships" do
      it { is_expected.to belong_to(:parent).optional }
      it { is_expected.to belong_to(:activitable_actor) }
      it { is_expected.to belong_to(:activitable_object) }
      it { is_expected.to belong_to(:activitable_target).optional }
      it { is_expected.to belong_to(:verb) }

      it do
        expect(activity)
          .to have_one(:actor).through(:activitable_actor).source(:activitable)
      end

      it { is_expected.to have_one(:activity_field) }
      it { is_expected.to have_many(:audiences).inverse_of(:activity) }
      it { is_expected.to have_many(:activity_objects) }
      it { is_expected.to have_many(:children) }
      it { is_expected.to have_many(:notifications).inverse_of(:activity) }
    end

    context "with validations" do
      it { is_expected.to validate_presence_of(:activitable_actor) }
      it { is_expected.to validate_presence_of(:activitable_object) }
      it { is_expected.to validate_presence_of(:verb) }
    end

    context "with scopes" do
      describe "newest_first" do
        let(:sql) { Activity.newest_first.to_sql }

        it do
          expect(sql)
            .to include('ORDER BY "socializer_activities"."created_at" DESC')
        end
      end

      describe "with_id" do
        let(:sql) { Activity.with_id(id: 1).to_sql }

        it do
          expect(sql).to include('WHERE "socializer_activities"."id" = 1')
        end
      end

      describe "with_activity_object_id" do
        let(:sql) { Activity.with_activity_object_id(id: 1).to_sql }

        let(:expected) do
          'WHERE "socializer_activities"."activity_object_id" = 1'
        end

        it do
          expect(sql).to include(expected)
        end
      end

      describe "with_actor_id" do
        let(:sql) { Activity.with_actor_id(id: 1).to_sql }

        it do
          expect(sql)
            .to include('WHERE "socializer_activities"."actor_id" = 1')
        end
      end

      describe "with_target_id" do
        let(:sql) { Activity.with_target_id(id: 1).to_sql }

        it do
          expect(sql)
            .to include('WHERE "socializer_activities"."target_id" = 1')
        end
      end
    end

    it do
      expect(activity)
        .to delegate_method(:activity_field_content)
        .to(:activity_field)
        .as(:content)
    end

    it do
      expect(activity)
        .to delegate_method(:verb_display_name)
        .to(:verb)
        .as(:display_name)
    end

    describe "#comments" do
      it { expect(activity.comments?).to eq(false) }

      describe "expected to be true" do
        let(:activity) { create(:activity) }
        let(:scope) { Audience.privacy.find_value(:public) }

        let(:comment_attributes) do
          { content: "Comment",
            activity_target_id: activity.id,
            activity_verb: "add",
            scope: scope }
        end

        let(:actor) { activity.actor }

        before do
          actor.comments.create!(comment_attributes)
        end

        it { expect(activity.comments?).to eq(true) }
      end
    end

    # TODO: Test return values
    it { expect(activity.actor).to be_kind_of(Socializer::Person) }
    it { expect(activity.object).to be_kind_of(Socializer::Note) }
    it { expect(activity.target).to be_kind_of(Socializer::Group) }

    describe ".stream" do
      let(:activity_object_person) do
        build(:activity_object_person)
      end

      let(:activity_object_group) { build(:activity_object_group) }
      let(:person) { activity_object_person.activitable }
      let(:group) { activity_object_group.activitable }

      let(:common_stream_attributes) do
        { actor_uid: person.id, viewer_id: person.id }
      end

      let(:group_stream_attributes) do
        { actor_uid: group.id, viewer_id: person.id }
      end

      # TODO: Test return values
      it { expect { Activity.stream }.to raise_error(ArgumentError) }

      it do
        expect(Activity.stream(viewer_id: person.id))
          .to be_kind_of(ActiveRecord::Relation)
      end

      it do
        expect(Activity.activity_stream(common_stream_attributes))
          .to be_kind_of(ActiveRecord::Relation)
      end

      it do
        expect(Activity.circle_stream(common_stream_attributes))
          .to be_kind_of(ActiveRecord::Relation)
      end

      it do
        expect(Activity.group_stream(group_stream_attributes))
          .to be_kind_of(ActiveRecord::Relation)
      end

      it do
        expect(Activity.person_stream(common_stream_attributes))
          .to be_kind_of(ActiveRecord::Relation)
      end
    end
  end
end
