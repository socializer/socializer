require 'rails_helper'

module Socializer
  RSpec.describe ActivityAudienceList, type: :service do
    describe 'when the activity argument is nil' do
      context '.new should raise an ArgumentError' do
        let(:audience_list) { ActivityAudienceList.new(activity: nil) }
        it { expect { audience_list }.to raise_error(ArgumentError) }
      end

      context '.perform should raise an ArgumentError' do
        let(:audience_list) { ActivityAudienceList.perform(activity: nil) }
        it { expect { audience_list }.to raise_error(ArgumentError) }
      end
    end

    describe 'when the activity argument is the wrong type' do
      let(:audience_list) { ActivityAudienceList.new(activity: Person.new) }
      it { expect { audience_list }.to raise_error(ArgumentError) }
    end

    describe '.perform' do
      let(:activity) { create(:socializer_activity) }
      let(:audience_list) { ActivityAudienceList.new(activity: activity) }

      it { expect(audience_list.perform).to be_kind_of(Array) }
    end
  end
end
