require 'spec_helper'

module Socializer
  describe GroupCategory, :type => :model do
    let(:group_category) { build(:socializer_group_category) }

    it 'has a valid factory' do
      expect(group_category).to be_valid
    end

    context 'mass assignment' do
      it { expect(group_category).to allow_mass_assignment_of(:name) }
    end

    context 'relationships' do
      it { expect(group_category).to belong_to(:group) }
    end

    context 'validations' do
      it { expect(group_category).to validate_presence_of(:name) }
    end
  end
end
