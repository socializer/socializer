require "rails_helper"

module Socializer
  RSpec.describe ApplicationDecorator, type: :decorator do
    context "created_at_time_ago" do
      let(:activity) { create(:activity) }
      let(:decorated_activity) { ActivityDecorator.new(activity) }
      let(:created_at) { activity.created_at.utc }
      let(:updated_at) { activity.updated_at.utc }

      context "when created_at and updated_at are equal" do
        let(:result) { decorated_activity.created_at_time_ago }
        let(:time_text) { created_at.strftime("%B %e, %Y %l:%M%P") }

        it do
          expect(result).to have_selector("time", text: time_text)
        end

        it do
          expect(result)
            .to have_selector("time[datetime='#{created_at.iso8601}']")
        end

        it do
          expect(result)
            .to have_selector("time[title='#{created_at.to_s(:short)}']")
        end

        it do
          expect(result).to have_selector("time[data-time-ago='moment.js']")
        end
      end

      context "when created_at and updated_at are different" do
        before do
          decorated_activity.updated_at = Time.zone.now + 1.hour
          decorated_activity.save!
        end

        let(:result) { decorated_activity.created_at_time_ago }
        let(:time_text) { created_at.strftime("%B %e, %Y %l:%M%P") }

        let(:time_title) do
          "#{created_at.to_s(:short)} (edited #{updated_at.to_s(:short)})"
        end

        it do
          expect(result).to have_selector("time", text: time_text)
        end

        it do
          expect(result)
            .to have_selector("time[datetime='#{created_at.iso8601}']")
        end

        it do
          expect(result)
            .to have_selector("time[title='#{time_title}']")
        end

        it do
          expect(result).to have_selector("time[data-time-ago='moment.js']")
        end
      end
    end
  end
end
