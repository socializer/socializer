require 'spec_helper'

module Socializer
  describe Person do
    let(:person) { build(:socializer_person) }

    it 'has a valid factory' do
      expect(person).to be_valid
    end

    context 'relationships' do
      it { expect(person).to have_one(:activity_object) }
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

    context '#circles' do
      let(:person) { build(:socializer_person_circles) }
      let(:circles) { person.activity_object.circles }
      it { expect(person.circles).to be_a(circles.class) }
      it { expect(person.circles).to eq(circles) }
    end

    context '#comments' do
      let(:person) { build(:socializer_person_comments) }
      let(:comments) { person.activity_object.comments }
      it { expect(person.comments).to be_a(comments.class) }
      it { expect(person.comments).to eq(comments) }
    end

    context '#groups' do
      let(:person) { build(:socializer_person_groups) }
      let(:groups) { person.activity_object.groups }
      it { expect(person.groups).to be_a(groups.class) }
      it { expect(person.groups).to eq(groups) }
    end

    context '#notes' do
      let(:person) { build(:socializer_person_notes) }
      let(:notes) { person.activity_object.notes }
      it { expect(person.notes).to be_a(notes.class) }
      it { expect(person.notes).to eq(notes) }
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

    context '#add_default_circle' do
      let(:person) { create(:socializer_person_circles) }

      before do
        person.add_default_circle
      end

      # TODO: Should test that circles includes Friends, Family, etc.
      it { expect(person.activity_object.circles).to have(4).items }
    end
  end
end
