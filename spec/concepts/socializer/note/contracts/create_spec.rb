# frozen_string_literal: true

require "rails_helper"

module Socializer
  RSpec.describe Note::Contracts::Create, type: :contract do
    let(:result) { subject.call(attributes) }
    let(:activity_verb) { Types::ActivityVerbs["post"] }

    let(:public_privacy) do
      Socializer::Audience.privacy.find_value(:public).value
    end

    let(:object_ids) { public_privacy }
    let(:content) { "Some Content" }

    let(:attributes) do
      { activity_verb: activity_verb,
        object_ids: object_ids,
        content: content }
    end

    context "when attributes are specified" do
      it "is valid" do
        expect(result).to be_success
      end
    end

    context "when attributes are not specified" do
      let(:attributes) { { } }

      it { expect(result).to be_failure }
      # it { expect(result.errors[:display_name]).to eq(["is missing"]) }
    end

    context "when attributes are invalid" do
      describe "when activity_verb is not 'post'" do
        let(:activity_verb) { Types::ActivityVerbs["like"] }

        it { expect(result).to be_failure }
      end

      describe "when content is empty" do
        let(:content) { nil }

        it { expect(result).to be_failure }
      end
    end
  end
end
