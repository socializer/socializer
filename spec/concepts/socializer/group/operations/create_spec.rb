# frozen_string_literal: true

require "rails_helper"

module Socializer
  RSpec.describe Group::Operations::Create, type: :operation do
    let(:result) { described_class.new(actor: actor).call(params: attributes) }
    let(:actor) { create(:person) }
    let(:failure) { result.failure }

    let(:attributes) do
      { display_name: "Group Name",
        privacy: Group.privacy.find_value(:public) }
    end

    describe ".call" do
      context "with no required attributes" do
        let(:attributes) do
          { display_name: nil, privacy: nil }
        end

        specify { expect(result).to be_failure }
        specify { expect(failure.success?).to be false }
        specify { expect(failure.errors).not_to be_nil }
      end

      context "with required attributes" do
        let(:group) { result.success[:group] }

        let(:notice_i18n) do
          I18n.t("socializer.model.create",
                 model: group.class.name.demodulize)
        end

        specify { expect(result).to be_success }
        specify { expect(group.valid?).to be true }
        specify { expect(group).to be_kind_of(Group) }
        specify { expect(group.persisted?).to be true }
        specify { expect(result.success[:notice]).to eq(notice_i18n) }
      end

      context "when display_name is not unique" do
        before do
          groups = actor.activity_object.groups
          groups.create!(attributes)
        end

        specify { expect(result).to be_failure }
        specify { expect(failure.success?).to be false }
        specify { expect(failure.errors).not_to be_nil }
      end
    end
  end
end
