require 'spec_helper'

module Socializer
  describe Authentication do
    let(:authentication) { build(:socializer_authentication) }

    it 'has a valid factory' do
      expect(authentication).to be_valid
    end

    it '#person' do
      expect(authentication).to respond_to(:person)
    end

    it '#provider' do
      expect(authentication).to respond_to(:provider)
    end

    it '#uid' do
      expect(authentication).to respond_to(:uid)
    end

    it '#image_url' do
      expect(authentication).to respond_to(:image_url)
    end

    context 'when last authentication for a person' do
      let(:last_authentication) { create(:socializer_authentication) }

      it 'cannot be deleted' do
        expect { last_authentication.destroy }.to raise_error
      end
    end
  end
end
