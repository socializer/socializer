require 'spec_helper'

module Socializer
  describe Authentication, type: :model do
    let(:authentication) { build(:socializer_authentication) }

    it 'has a valid factory' do
      expect(authentication).to be_valid
    end

    context 'mass assignment' do
      it { expect(authentication).to allow_mass_assignment_of(:provider) }
      it { expect(authentication).to allow_mass_assignment_of(:uid) }
      it { expect(authentication).to allow_mass_assignment_of(:image_url) }
    end

    context 'relationships' do
      it { expect(authentication).to belong_to(:person) }
    end

    context 'when last authentication for a person' do
      let(:last_authentication) { create(:socializer_authentication) }

      it 'cannot be deleted' do
        expect { last_authentication.destroy }.to raise_error
      end
    end
  end
end
