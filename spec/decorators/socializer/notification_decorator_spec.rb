# frozen_string_literal: true

require "rails_helper"

module Socializer
  RSpec.describe NotificationDecorator do
    let(:notification) { create(:notification) }
    let(:decorated_notification) { described_class.new(notification) }

    before do
      person = create(:person)

      without_partial_double_verification do
        allow(helper).to receive(:current_user).and_return(person)
      end
    end

    describe "card_class" do
      context "when unread" do
        specify do
          expect(decorated_notification.card_class(index: 1))
            .to eq("panel-default")
        end
      end

      context "when read" do
        let(:notification) { create(:notification, read: true) }

        specify do
          expect(decorated_notification.card_class(index: 1))
            .to eq("panel-default bg-muted")
        end
      end

      context "when index is <= the unread_notifications_count" do
        specify do
          expect(decorated_notification.card_class(index: 0))
            .to eq("panel-success bg-success")
        end
      end
    end
  end
end
