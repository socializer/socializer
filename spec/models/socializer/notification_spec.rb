require 'spec_helper'

module Socializer
  describe Notification do

    # Define a person for common testd instead of build one for each
    let(:notification) { FactoryGirl.build(:socializer_notification) }

    it 'has a valid factory' do
      expect(notification).to be_valid
    end

    it '#respond to person' do
      expect(notification).to respond_to(:person)
    end

    it '#person must be present' do
      expect(notification.person).to_not be_nil
    end

    it '#respond to activity' do
      expect(notification).to respond_to(:activity)
    end

    it '#activity must be present' do
      expect(notification.activity).to_not be_nil
    end

  end
end
