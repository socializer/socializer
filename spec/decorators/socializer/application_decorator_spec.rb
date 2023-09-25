# frozen_string_literal: true

require "rails_helper"

module Socializer
  RSpec.describe ApplicationDecorator do
    describe "created_at_time_ago" do
      let(:decorated_activity) { ActivityDecorator.new(create(:activity)) }
      let(:created_at) { decorated_activity.created_at.utc }
      let(:updated_at) { decorated_activity.updated_at.utc }
      let(:time_text) { created_at.strftime("%B %e, %Y %l:%M%P") }

      context "when created_at and updated_at are equal" do
        specify do
          expect(decorated_activity.created_at_time_ago)
            .to have_css("time", text: time_text)
        end

        specify do
          expect(decorated_activity.created_at_time_ago)
            .to have_selector("time[datetime='#{created_at.iso8601}']")
        end

        specify do
          expect(decorated_activity.created_at_time_ago)
            .to have_selector("time[title='#{created_at.to_fs(:short)}']")
        end

        specify do
          expect(decorated_activity.created_at_time_ago)
            .to have_css("time[data-time-ago='moment.js']")
        end
      end

      context "when created_at and updated_at are different" do
        before do
          decorated_activity.updated_at = 1.hour.from_now
          decorated_activity.save!
        end

        let(:time_title) do
          "#{created_at.to_fs(:short)} (edited #{updated_at.to_fs(:short)})"
        end

        specify do
          expect(decorated_activity.created_at_time_ago)
            .to have_css("time", text: time_text)
        end

        specify do
          expect(decorated_activity.created_at_time_ago)
            .to have_selector("time[datetime='#{created_at.iso8601}']")
        end

        specify do
          expect(decorated_activity.created_at_time_ago)
            .to have_selector("time[title='#{time_title}']")
        end

        specify do
          expect(decorated_activity.created_at_time_ago)
            .to have_css("time[data-time-ago='moment.js']")
        end
      end
    end
  end
end
