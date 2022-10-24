# frozen_string_literal: true

require "rails_helper"

module Socializer
  RSpec.describe Activity::Services::Share do
    let(:activity_object) { create(:activity_object) }
    let(:actor) { create(:person) }
    let(:share) { described_class.new(actor:) }

    let(:share_attributes) do
      { activity_id: activity_object.id,
        object_ids: Socializer::Audience.privacy.find_value(:public).value,
        content: "Share" }
    end

    let(:results) { share.call(params: share_attributes) }

    it { expect(results.persisted?).to be(true) }
    it { expect(results.actor_id).to eq(actor.guid) }
    it { expect(results.activity_object_id).to eq(activity_object.id) }
    it { expect(results.verb.display_name).to eq("share") }
    it { expect(results.activity_field_content).to eq("Share") }

    context "with no content" do
      before do
        share_attributes[:content] = nil
      end

      it { expect(results.activity_field_content).to be_nil }
    end
  end
end
