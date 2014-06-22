require 'rails_helper'

module Socializer
  RSpec.describe Person, type: :model do
    let(:person) { build(:socializer_person) }

    it 'has a valid factory' do
      expect(person).to be_valid
    end

    context 'mass assignment' do
      it { is_expected.to allow_mass_assignment_of(:display_name) }
      it { is_expected.to allow_mass_assignment_of(:email) }
      it { is_expected.to allow_mass_assignment_of(:language) }
      it { is_expected.to allow_mass_assignment_of(:avatar_provider) }
      it { is_expected.to allow_mass_assignment_of(:tagline) }
      it { is_expected.to allow_mass_assignment_of(:introduction) }
      it { is_expected.to allow_mass_assignment_of(:bragging_rights) }
      it { is_expected.to allow_mass_assignment_of(:occupation) }
      it { is_expected.to allow_mass_assignment_of(:skills) }
      it { is_expected.to allow_mass_assignment_of(:gender) }
      it { is_expected.to allow_mass_assignment_of(:looking_for_friends) }
      it { is_expected.to allow_mass_assignment_of(:looking_for_dating) }
      it { is_expected.to allow_mass_assignment_of(:looking_for_relationship) }
      it { is_expected.to allow_mass_assignment_of(:looking_for_networking) }
      it { is_expected.to allow_mass_assignment_of(:birthdate) }
      it { is_expected.to allow_mass_assignment_of(:relationship) }
      it { is_expected.to allow_mass_assignment_of(:other_names) }
    end

    context 'relationships' do
      it { is_expected.to have_one(:activity_object) }
      it { is_expected.to have_many(:authentications) }
      it { is_expected.to have_many(:addresses) }
      it { is_expected.to have_many(:contributions) }
      it { is_expected.to have_many(:educations) }
      it { is_expected.to have_many(:employments) }
      it { is_expected.to have_many(:links) }
      it { is_expected.to have_many(:phones) }
      it { is_expected.to have_many(:places) }
    end

    context 'validations' do
      it { is_expected.to ensure_inclusion_of(:avatar_provider).in_array(%w(TWITTER FACEBOOK LINKEDIN GRAVATAR)) }
    end

    it '.create_with_omniauth' do
      expect(Socializer::Person).to respond_to(:create_with_omniauth)
    end

    context '.audience_list' do
      it { expect { Person.audience_list }.to raise_error(ArgumentError) }
      it { expect(Person.audience_list(nil)).to eq(nil) }
      it do
        create(:socializer_person)
        expect(Person.audience_list('n').first.display_name).to include('name')
      end
    end

    context '#audience_list' do
      let(:person) { build(:socializer_person_circles) }
      it { expect { person.audience_list }.to raise_error(ArgumentError) }
      it { expect { person.audience_list(:cricles) }.to raise_error(ArgumentError) }

      # TODO: Test return values
      it { expect(person.audience_list(:circles, nil)).to be_kind_of(ActiveRecord::AssociationRelation) }
      it { expect(person.audience_list(:circles, 'f')).to be_kind_of(ActiveRecord::AssociationRelation) }

      it { expect(person.audience_list(:unknown, nil)).to eq(nil) }
    end

    context '#services' do
      it do
        person = create(:socializer_person, avatar_provider: 'FACEBOOK')
        person.authentications.create(provider: 'facebook', image_url: 'http://facebook.com')

        expect(person.services.to_sql).to include("!= 'Identity'")
        expect(person.services.count).to eq(1)
        expect(person.services.find_by(provider: 'facebook').provider).to eq('facebook')
      end
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

    context '#contacts' do
      let(:person) { build(:socializer_person_circles) }
      # TODO: Test return values
      it { expect(person.contacts).to be_kind_of(Array) }
    end

    context '#contact_of' do
      let(:person) { build(:socializer_person_circles) }
      # TODO: Test return values
      it { expect(person.contact_of).to be_kind_of(Array) }
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

    context '#add_default_circles' do
      let(:person) { build(:socializer_person_circles) }
      let(:circles) { person.activity_object.circles }

      before do
        person.add_default_circles
      end

      it { expect(person.activity_object.circles.size).to eq(4) }
      it { expect(circles.find_by(name: 'Friends').name).to eq('Friends') }
      it { expect(circles.find_by(name: 'Family').name).to eq('Family') }
      it { expect(circles.find_by(name: 'Acquaintances').name).to eq('Acquaintances') }
      it { expect(circles.find_by(name: 'Following').name).to eq('Following') }
    end
  end
end
