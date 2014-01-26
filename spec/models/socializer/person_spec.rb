require 'spec_helper'

module Socializer
  describe Group do
    it 'has a valid factory' do
      expect(build(:socializer_person)).to be_valid
    end

    it '.create_with_omniauth' do
      expect(Socializer::Person).to respond_to(:create_with_omniauth)
    end

    it '#authentications' do
      expect(build(:socializer_person)).to respond_to(:authentications)
    end

    it '#services' do
      expect(build(:socializer_person)).to respond_to(:services)
    end

    it '#circles' do
      expect(build(:socializer_person)).to respond_to(:circles)
    end

    it '#comments' do
      expect(build(:socializer_person)).to respond_to(:comments)
    end

    it '#notes' do
      expect(build(:socializer_person)).to respond_to(:notes)
    end

    it '#groups' do
      expect(build(:socializer_person)).to respond_to(:groups)
    end

    it '#memberships' do
      expect(build(:socializer_person)).to respond_to(:memberships)
    end

    it '#contacts' do
      expect(build(:socializer_person)).to respond_to(:contacts)
    end

    it '#contact_of' do
      expect(build(:socializer_person)).to respond_to(:contact_of)
    end

    it '#likes' do
      expect(build(:socializer_person)).to respond_to(:likes)
    end

    it '#likes?' do
      expect(build(:socializer_person)).to respond_to(:likes?)
    end

    it '#pending_memberships_invites' do
      expect(build(:socializer_person)).to respond_to(:pending_memberships_invites)
    end

    it '#avatar_url' do
      expect(build(:socializer_person)).to respond_to(:avatar_url)
    end

  end
end
