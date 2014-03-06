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

    context '#services' do
      it { expect(person).to respond_to(:services) }
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

    context '#avatar_url' do
      it 'when the provider is Facebook, LinkedIn, or Twitter' do
        %w( FACEBOOK LINKEDIN TWITTER ).each do |p|
          person = create(:socializer_person, avatar_provider: p)
          person.authentications.create(provider: p.downcase, image_url: "http://#{p.downcase}.com")
          expect(person.avatar_url).to include(p.downcase)
        end
      end

      context 'when the provider is gravatar' do
        it { expect(person.avatar_url).to include('http://www.gravatar.com/avatar/') }

        context 'with a blank email' do
          let(:person) { build(:socializer_person, email: nil) }
          it { expect(person.avatar_url).to eq(nil) }
        end
      end
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
      let(:person) { build(:socializer_person_circles) }
      let(:circles) { person.activity_object.circles }

      before do
        person.add_default_circle
      end

      it { expect(person.activity_object.circles).to have(4).items }
      it { expect(circles.find_by(name: 'Friends').name).to eq('Friends') }
      it { expect(circles.find_by(name: 'Family').name).to eq('Family') }
      it { expect(circles.find_by(name: 'Acquaintances').name).to eq('Acquaintances') }
      it { expect(circles.find_by(name: 'Following').name).to eq('Following') }
    end
  end
end
