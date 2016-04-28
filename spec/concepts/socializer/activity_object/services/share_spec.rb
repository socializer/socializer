require "rails_helper"

module Socializer
  class ActivityObject
    module Services
      RSpec.describe Share, type: :service do
        let(:activity_object) { create(:activity_object) }
        let(:actor) { create(:person) }
        let(:share) { Share.new(share_attributes) }

        let(:object_ids) do
          Socializer::Audience.privacy.find_value(:public).value.split(",")
        end

        let(:share_attributes) do
          { actor: actor,
            activity_object: activity_object,
            object_ids: object_ids,
            content: "Share"
          }
        end

        let(:results) { share.call }

        it { expect(results.persisted?).to eq(true) }
        it { expect(results.actor_id).to eq(actor.guid) }
        it { expect(results.activity_object_id).to eq(activity_object.id) }
        it { expect(results.verb.display_name).to eq("share") }
        it { expect(results.activity_field_content).to eq("Share") }

        context "with no content" do
          let(:share_attributes) do
            { actor: actor,
              activity_object: activity_object,
              object_ids: object_ids,
              content: nil
            }
          end

          let(:results) { share.call }

          it { expect(results.activity_field_content).to eq(nil) }
        end
      end
    end
  end
end
