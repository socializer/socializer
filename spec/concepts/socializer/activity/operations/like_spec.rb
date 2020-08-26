# frozen_string_literal: true

require "rails_helper"

module Socializer
  RSpec.describe Activity::Operations::Like, type: :operation do
    let(:actor) { create(:person) }
    let(:liked_activity_object) { create(:activity_object) }
    let(:like) { described_class.new(actor: actor) }

    let(:results) do
      like.call(activity_object: liked_activity_object).success[:activity]
    end

    it { expect(results.persisted?).to eq(true) }
    it { expect(results.verb.display_name).to eq("like") }
    it { expect(results).to be_kind_of(Socializer::Activity) }

    describe "check the like_count and liked_by" do
      before do
        like.call(activity_object: liked_activity_object)

        liked_activity_object.reload
      end

      it { expect(liked_activity_object.like_count).to eq(1) }
      it { expect(liked_activity_object.liked_by.size).to eq(1) }
    end

    context "when liked you can't like again" do
      let(:results) { like.call(activity_object: liked_activity_object).failure }

      before do
        like.call(activity_object: liked_activity_object)
        like.call(activity_object: liked_activity_object)

        liked_activity_object.reload
      end

      it { expect(liked_activity_object.like_count).to eq(1) }

      it "must be ActiveRecord::Relation" do
        expect(results)
          .to be_kind_of(ActiveRecord::Relation)
      end
    end

    context "with validate" do
      let(:result) { like.validate(attributes) }

      # context "when validation is successful" do
      #   let(:attributes) do
      #     { actor_id: actor.guid,
      #       activity_object_id: liked_activity_object.id,
      #       object_ids: "public",
      #       verb: "like" }
      #   end

      #   it { expect(result).to be_success }
      #   it { expect(result.success.values.to_h).to eq(attributes) }
      # end

      context "when validation fails" do
        let(:attributes) { { } }
        let(:failure) { result.failure }

        it { expect(result).to be_failure }
        it { expect(result).to be_kind_of(Dry::Monads::Result::Failure) }
        it { expect(failure.success?).to be false }

        it { expect(failure.errors).not_to be_nil }
      end
    end
  end
end
