require 'spec_helper'

module Socializer
  RSpec.describe Notification, type: :model do
    # Define a person for common testd instead of build one for each
    let(:notification) { build(:socializer_notification) }

    it 'has a valid factory' do
      expect(notification).to be_valid
    end

    context 'mass assignment' do
      it { is_expected.to allow_mass_assignment_of(:read) }
    end

    context 'relationships' do
      it { is_expected.to belong_to(:activity) }
      it { is_expected.to belong_to(:activity_object) }
    end

    context 'validations' do
      it { is_expected.to validate_presence_of(:activity_id) }
      it { is_expected.to validate_presence_of(:activity_object_id) }
    end
  end
end
