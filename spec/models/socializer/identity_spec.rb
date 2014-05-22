require 'spec_helper'

module Socializer
  describe Identity, type: :model do
    let(:identity) { build(:socializer_identity) }

    it 'has a valid factory' do
      expect(identity).to be_valid
    end

    context 'mass assignment' do
      it { expect(identity).to allow_mass_assignment_of(:name) }
      it { expect(identity).to allow_mass_assignment_of(:email) }
      it { expect(identity).to allow_mass_assignment_of(:password) }
      it { expect(identity).to allow_mass_assignment_of(:password_confirmation) }
    end

    context 'validations' do
      it { expect(identity).to validate_presence_of(:name) }
      it { expect(identity).to validate_presence_of(:email) }
      it { expect(create(:socializer_identity)).to validate_uniqueness_of(:email) }
    end

    it '#password' do
      expect(identity).to respond_to(:password)
    end

    it '#password_confirmation' do
      expect(identity).to respond_to(:password_confirmation)
    end
  end
end
