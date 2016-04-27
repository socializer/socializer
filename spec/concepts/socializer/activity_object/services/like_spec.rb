require "rails_helper"

module Socializer
  class ActivityObject
    module Services
      RSpec.describe Like, type: :service do
        let(:liking_person) { create(:person) }
        let(:liked_activity_object) { create(:activity_object) }
        let(:like) { Like.new(like_attributes) }

        let(:like_attributes) do
          { actor: liking_person,
            activity_object: liked_activity_object
          }
        end

        context "check return type when liking an unliked object" do
          it { expect(like.call).to be_kind_of(Socializer::Activity) }
        end

        context "check the like_count and liked_by" do
          before do
            like.call

            liked_activity_object.reload
          end

          it { expect(liked_activity_object.like_count).to eq(1) }
          it { expect(liked_activity_object.liked_by.size).to eq(1) }
        end

        context "can't like again" do
          before do
            like.call
            like.call

            liked_activity_object.reload
          end

          it { expect(liked_activity_object.like_count).to eq(1) }

          it "should be Socializer::Activity::ActiveRecord_Relation" do
            expect(like.call)
              .to be_kind_of(Socializer::Activity::ActiveRecord_Relation)
          end
        end
      end
    end
  end
end
