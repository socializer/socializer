require 'spec_helper'

module Socializer
  RSpec.describe GroupLink, type: :model do
    let(:group_link) { build(:socializer_group_link) }

    it 'has a valid factory' do
      expect(group_link).to be_valid
    end

    context 'mass assignment' do
      it { expect(group_link).to allow_mass_assignment_of(:label) }
      it { expect(group_link).to allow_mass_assignment_of(:url) }
    end

    context 'relationships' do
      it { expect(group_link).to belong_to(:group) }
    end

    context 'validations' do
      it { expect(group_link).to validate_presence_of(:label) }
      it { expect(group_link).to validate_presence_of(:url) }
    end
  end
end
