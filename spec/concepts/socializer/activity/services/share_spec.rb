# frozen_string_literal: true

require "rails_helper"

module Socializer
  class Activity
    module Services
      RSpec.describe Share, type: :service do
        let(:activity_object) { create(:activity_object) }
        let(:actor) { create(:person) }
        let(:share) { Share.new(actor: actor) }

        let(:public_privacy) do
          Socializer::Audience.privacy.find_value(:public).value
        end

        let(:object_ids) { public_privacy }

        let(:share_attributes) do
          ActionController::Parameters.new(
            activity_id: activity_object.id,
            object_ids: object_ids,
            content: "Share"
          )
        end

        let(:results) { share.call(params: share_attributes) }

        it { expect(results.persisted?).to eq(true) }
        it { expect(results.actor_id).to eq(actor.guid) }
        it { expect(results.activity_object_id).to eq(activity_object.id) }
        it { expect(results.verb.display_name).to eq("share") }
        it { expect(results.activity_field_content).to eq("Share") }

        context "with no content" do
          let(:share_attributes) do
            ActionController::Parameters.new(
              activity_id: activity_object.id,
              object_ids: object_ids,
              content: nil
            )
          end

          let(:results) { share.call(params: share_attributes) }

          it { expect(results.activity_field_content).to eq(nil) }
        end

        context "#object_ids as nil" do
          let(:object_ids) { "" }
          let(:results) { share.call(params: share_attributes) }

          it { expect(results.persisted?).to eq(false) }
        end

        context "#object_ids as an array of non strings" do
          let(:object_ids) { [1, 2, 3] }
          let(:results) { share.call(params: share_attributes) }

          it { expect(results.persisted?).to eq(false) }
        end

        context "#object_ids as an array of strings" do
          let(:object_ids) { [public_privacy, circles_privacy] }

          let(:circles_privacy) do
            Socializer::Audience.privacy.find_value(:circles).value
          end

          let(:results) { share.call(params: share_attributes) }
          let(:public_audience) { results.audiences.where(privacy: "public") }
          let(:circles_audience) { results.audiences.where(privacy: "circles") }

          it { expect(results.persisted?).to eq(true) }
          it { expect(public_audience.present?).to eq(true) }
          it { expect(circles_audience.present?).to eq(true) }
        end
      end
    end
  end
end
