# frozen_string_literal: true

require "rails_helper"

module Socializer
  class Activity
    module Services
      RSpec.describe Like, type: :service do
        let(:liking_person) { create(:person) }
        let(:liked_activity_object) { create(:activity_object) }
        let(:like) { Like.new(actor: liking_person) }
        let(:results) { like.call(like_attributes) }

        let(:like_attributes) do
          { activity_object: liked_activity_object }
        end

        it { expect(results.persisted?).to eq(true) }
        it { expect(results.verb.display_name).to eq("like") }
        it { expect(results).to be_kind_of(Socializer::Activity) }

        describe "check the like_count and liked_by" do
          before do
            like.call(like_attributes)

            liked_activity_object.reload
          end

          it { expect(liked_activity_object.like_count).to eq(1) }
          it { expect(liked_activity_object.liked_by.size).to eq(1) }
        end

        context "when liked you can't like again" do
          before do
            like.call(like_attributes)
            like.call(like_attributes)

            liked_activity_object.reload
          end

          it { expect(liked_activity_object.like_count).to eq(1) }

          it "must be ActiveRecord::Relation" do
            expect(results)
              .to be_kind_of(ActiveRecord::Relation)
          end
        end
      end
    end
  end
end
