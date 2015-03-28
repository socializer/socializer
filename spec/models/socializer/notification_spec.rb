require 'rails_helper'

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
      it { is_expected.to belong_to(:activity).inverse_of(:notifications) }
      it { is_expected.to belong_to(:activity_object).inverse_of(:notifications) }
    end

    context 'validations' do
      it { is_expected.to validate_presence_of(:activity_id) }
      it { is_expected.to validate_presence_of(:activity_object_id) }
    end

    context '#mark_as_read' do
      let(:notification) { build(:socializer_notification, read: false) }

      it { expect(notification.read).to be false }

      context 'read is false' do
        before { notification.mark_as_read }
        it { expect(notification.read).to be true }
      end
    end

    context '#unread?' do
      let(:notification) { build(:socializer_notification, read: false) }

      context 'read is false' do
        it { expect(notification.unread?).to be true }
      end

      context 'read is true' do
        let(:notification) { build(:socializer_notification, read: true) }
        it { expect(notification.unread?).to be false }
      end
    end
  end
end
