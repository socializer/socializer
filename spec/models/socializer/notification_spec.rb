# frozen_string_literal: true

require "rails_helper"

module Socializer
  RSpec.describe Notification, type: :model do
    # Define a person for common testd instead of build one for each
    let(:notification) { build(:notification) }

    it "has a valid factory" do
      expect(notification).to be_valid
    end

    context "with relationships" do
      specify { is_expected.to belong_to(:activity).inverse_of(:notifications) }

      specify do
        expect(notification).to belong_to(:activity_object)
          .inverse_of(:notifications)
          .counter_cache(:unread_notifications_count)
      end
    end

    # context "with validations" do
    # end

    context "with scopes" do
      describe "newest_first" do
        let(:sql) { described_class.newest_first.to_sql }

        specify do
          expect(sql)
            .to include('ORDER BY "socializer_notifications"."created_at" DESC')
        end
      end
    end

    describe "#mark_as_read" do
      let(:notification) { build(:notification, read: false) }

      specify { expect(notification.read).to be false }

      context "when read is false" do
        before { notification.mark_as_read }

        specify { expect(notification.read).to be true }
      end
    end

    describe "#unread?" do
      let(:notification) { build(:notification, read: false) }

      context "when read is false" do
        specify { expect(notification.unread?).to be true }
      end

      context "when read is true" do
        let(:notification) { build(:notification, read: true) }

        specify { expect(notification.unread?).to be false }
      end
    end
  end
end
