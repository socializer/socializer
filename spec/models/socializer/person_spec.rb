require "rails_helper"

module Socializer
  RSpec.describe Person, type: :model do
    let(:person) { build(:socializer_person) }

    it "has a valid factory" do
      expect(person).to be_valid
    end

    context "mass assignment" do
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

    context "relationships" do
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

    context "validations" do
      it { is_expected.to validate_inclusion_of(:avatar_provider).in_array(%w(TWITTER FACEBOOK LINKEDIN GRAVATAR)) }
    end

    it { is_expected.to enumerize(:gender).in(:unknown, :female, :male).with_default(:unknown) }
    it { is_expected.to enumerize(:relationship).in(:unknown, :single, :relationship, :engaged, :married, :complicated, :open, :widowed, :domestic, :civil).with_default(:unknown) }

    it ".create_with_omniauth" do
      expect(Socializer::Person).to respond_to(:create_with_omniauth)
    end

    context "#services" do
      it do
        person = create(:socializer_person, avatar_provider: "FACEBOOK")
        person.authentications.create(provider: "facebook", image_url: "http://facebook.com", uid: 1)

        expect(person.services.to_sql).to include("!= 'identity'")
        expect(person.services.count).to eq(1)
        expect(person.services.find_by(provider: "facebook").provider).to eq("facebook")
      end
    end

    context "#circles" do
      let(:person) { build(:socializer_person_circles) }
      let(:circles) { person.activity_object.circles }
      it { expect(person.circles).to be_a(circles.class) }
      it { expect(person.circles).to eq(circles) }
    end

    context "#comments" do
      let(:person) { build(:socializer_person_comments) }
      let(:comments) { person.activity_object.comments }
      it { expect(person.comments).to be_a(comments.class) }
      it { expect(person.comments).to eq(comments) }
    end

    context "#groups" do
      let(:person) { build(:socializer_person_groups) }
      let(:groups) { person.activity_object.groups }
      it { expect(person.groups).to be_a(groups.class) }
      it { expect(person.groups).to eq(groups) }
    end

    context "#notes" do
      let(:person) { build(:socializer_person_notes) }
      let(:notes) { person.activity_object.notes }
      it { expect(person.notes).to be_a(notes.class) }
      it { expect(person.notes).to eq(notes) }
    end

    it "#memberships" do
      expect(person).to respond_to(:memberships)
    end

    it "#notifications" do
      expect(person).to respond_to(:received_notifications)
    end

    context "#contacts" do
      let(:person) { build(:socializer_person_circles) }
      # TODO: Test return values
      it { expect(person.contacts).to be_kind_of(ActiveRecord::Associations::CollectionProxy) }
    end

    context "#contact_of" do
      let(:person) { build(:socializer_person_circles) }
      # TODO: Test return values
      it { expect(person.contact_of).to be_kind_of(ActiveRecord::Relation) }
    end

    it "#likes" do
      expect(person).to respond_to(:likes)
    end

    it "#likes?" do
      expect(person).to respond_to(:likes?)
    end

    it "#pending_memberships_invites" do
      expect(person).to respond_to(:pending_memberships_invites)
    end

    it "accepts known avatar_provider" do
      %w( TWITTER FACEBOOK LINKEDIN GRAVATAR ).each do |provider|
        expect(build(:socializer_person, avatar_provider: provider)).to be_valid
      end
    end

    it "rejects unknown avatar_provider" do
      %w( IDENTITY TEST DUMMY OTHER ).each do |provider|
        expect(build(:socializer_person, avatar_provider: provider)).to be_invalid
      end
    end
  end
end
