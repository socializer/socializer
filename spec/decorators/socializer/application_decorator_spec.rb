require 'rails_helper'

module Socializer
  RSpec.describe ApplicationDecorator, type: :decorator do
    context 'created_at_time_ago' do
      let(:activity) { create(:socializer_activity) }
      let(:decorated_activity) { ActivityDecorator.new(activity) }
      let(:created_at) { activity.created_at.to_time.utc }
      let(:updated_at) { activity.updated_at.to_time.utc }

      context 'when created_at and updated_at are equal' do
        let(:result) { decorated_activity.created_at_time_ago }

        it { expect(result).to have_selector('time', text: "#{created_at.strftime('%B %e, %Y %l:%M%P')}") }
        it { expect(result).to have_selector("time[datetime='#{created_at.iso8601}']") }
        it { expect(result).to have_selector("time[title='#{created_at.to_s(:short)}']") }
        it { expect(result).to have_selector('time[data-time-ago="moment.js"]') }
      end

      context 'when created_at and updated_at are different' do
        before do
          decorated_activity.updated_at = Time.zone.now + 1.hour
          decorated_activity.save!
        end

        let(:result) { decorated_activity.created_at_time_ago }

        it { expect(result).to have_selector('time', text: "#{created_at.strftime('%B %e, %Y %l:%M%P')}") }
        it { expect(result).to have_selector("time[datetime='#{created_at.iso8601}']") }
        it { expect(result).to have_selector("time[title='#{created_at.to_s(:short)} (edited #{updated_at.to_s(:short)})']") }
        it { expect(result).to have_selector('time[data-time-ago="moment.js"]') }
      end
    end
  end
end
