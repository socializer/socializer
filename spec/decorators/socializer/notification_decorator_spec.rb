# frozen_string_literal: true

require "rails_helper"

module Socializer
  RSpec.describe NotificationDecorator, type: :decorator do
    let(:notification) { create(:notification) }
    let(:decorated_notification) { NotificationDecorator.new(notification) }

    before do
      person = create(:person)
      allow(helper).to receive(:current_user).and_return(person)
    end

    describe "card_class" do
      context "when unread" do
        it do
          expect(decorated_notification.card_class(index: 1))
            .to eq("panel-default")
        end
      end

      context "when read" do
        let(:notification) { create(:notification, read: true) }

        it do
          expect(decorated_notification.card_class(index: 1))
            .to eq("panel-default bg-muted")
        end
      end

      context "when index is <= the unread_notifications_count" do
        it do
          expect(decorated_notification.card_class(index: 0))
            .to eq("panel-success bg-success")
        end
      end
    end
  end
end
