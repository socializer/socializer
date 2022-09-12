# frozen_string_literal: true

require "rails_helper"

module Socializer
  RSpec.describe Activity::Services::Like, type: :service do
    let(:liking_person) { create(:person) }
    let(:liked_activity_object) { create(:activity_object) }
    let(:like) { described_class.new(actor: liking_person) }
    let(:results) { like.call(activity_object: liked_activity_object) }

    it { expect(results.persisted?).to be(true) }
    it { expect(results.verb.display_name).to eq("like") }
    it { expect(results).to be_a(Socializer::Activity) }

    describe "check the like_count and liked_by" do
      before do
        like.call(activity_object: liked_activity_object)

        liked_activity_object.reload
      end

      it { expect(liked_activity_object.like_count).to eq(1) }
      it { expect(liked_activity_object.liked_by.size).to eq(1) }
    end

    context "when liked you can't like again" do
      before do
        like.call(activity_object: liked_activity_object)
        like.call(activity_object: liked_activity_object)

        liked_activity_object.reload
      end

      it { expect(liked_activity_object.like_count).to eq(1) }

      it "must be ActiveRecord::Relation" do
        expect(results)
          .to be_a(ActiveRecord::Relation)
      end
    end
  end
end
