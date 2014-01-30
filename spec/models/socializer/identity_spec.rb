require 'spec_helper'

module Socializer
  describe Identity do
    let(:identity) { build(:socializer_identity) }

    it 'has a valid factory' do
      expect(identity).to be_valid
    end

    it '#name' do
      expect(identity).to respond_to(:name)
    end

    it '#email' do
      expect(identity).to respond_to(:email)
    end

    it '#password' do
      expect(identity).to respond_to(:password)
    end

    it '#password_confirmation' do
      expect(identity).to respond_to(:password_confirmation)
    end
  end
end
