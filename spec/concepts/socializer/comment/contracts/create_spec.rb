# frozen_string_literal: true

require "rails_helper"

module Socializer
  RSpec.describe Comment::Contracts::Create, type: :contract do
    let(:result) { subject.call(attributes) }
    let(:activity_verb) { Types::ActivityVerbs["add"] }
    let(:content) { "Some Content" }

    let(:attributes) do
      { activity_verb: activity_verb,
        content: content }
    end

    context "when attributes are specified" do
      it "is valid" do
        expect(result).to be_success
      end
    end

    context "when attributes are not specified" do
      let(:attributes) { {} }

      specify { expect(result).to be_failure }
    end

    context "when attributes are invalid" do
      describe "when activity_verb is not 'add'" do
        let(:activity_verb) { Types::ActivityVerbs["like"] }

        specify { expect(result).to be_failure }
      end

      describe "when content is empty" do
        let(:content) { nil }

        specify { expect(result).to be_failure }
      end
    end
  end
end
