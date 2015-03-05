require 'rails_helper'

module Socializer
  RSpec.describe Tie, type: :model do
    let(:tie) { build(:socializer_tie) }

    it 'has a valid factory' do
      expect(tie).to be_valid
    end

    context 'mass assignment' do
      it { is_expected.to allow_mass_assignment_of(:contact_id) }
    end

    context 'relationships' do
      it { is_expected.to belong_to(:circle) }
      it { is_expected.to belong_to(:activity_contact).class_name('ActivityObject').with_foreign_key('contact_id').inverse_of(:ties) }
    end

    # TODO: Test return values
    it { expect(tie.contact).to be_kind_of(Socializer::Person) }
  end
end
