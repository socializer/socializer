require 'spec_helper'

module Socializer
  describe Person do
    let(:person) { build(:socializer_person) }

    it 'has a valid factory' do
      expect(person).to be_valid
    end

    context 'relationships' do
      it { expect(person).to have_many(:authentications) }
      it { expect(person).to have_many(:addresses) }
      it { expect(person).to have_many(:contributions) }
      it { expect(person).to have_many(:educations) }
      it { expect(person).to have_many(:employments) }
      it { expect(person).to have_many(:links) }
      it { expect(person).to have_many(:phones) }
      it { expect(person).to have_many(:places) }
    end

    it '.create_with_omniauth' do
      expect(Socializer::Person).to respond_to(:create_with_omniauth)
    end

    it '#services' do
      expect(person).to respond_to(:services)
    end

    it '#circles' do
      expect(person).to respond_to(:circles)
    end

    it '#comments' do
      expect(person).to respond_to(:comments)
    end

    it '#notes' do
      expect(person).to respond_to(:notes)
    end

    it '#groups' do
      expect(person).to respond_to(:groups)
    end

    it '#memberships' do
      expect(person).to respond_to(:memberships)
    end

    it '#notifications' do
      expect(person).to respond_to(:received_notifications)
    end

    it '#contacts' do
      expect(person).to respond_to(:contacts)
    end

    it '#contact_of' do
      expect(person).to respond_to(:contact_of)
    end

    it '#likes' do
      expect(person).to respond_to(:likes)
    end

    it '#likes?' do
      expect(person).to respond_to(:likes?)
    end

    it '#pending_memberships_invites' do
      expect(person).to respond_to(:pending_memberships_invites)
    end

    it '#avatar_url' do
      expect(person).to respond_to(:avatar_url)
    end

    it 'accepts known avatar_provider' do
      %w( TWITTER FACEBOOK LINKEDIN GRAVATAR ).each do |p|
        expect(build(:socializer_person, avatar_provider: p)).to be_valid
      end
    end

    it 'rejects unknown avatar_provider' do
      %w( IDENTITY TEST DUMMY OTHER ).each do |p|
        expect(build(:socializer_person, avatar_provider: p)).to be_invalid
      end
    end

  end
end
