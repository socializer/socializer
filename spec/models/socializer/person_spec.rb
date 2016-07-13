# frozen_string_literal: true

require "rails_helper"

module Socializer
  RSpec.describe Person, type: :model do
    let(:person) { build(:person) }
    let(:valid_providers) { %w(TWITTER FACEBOOK LINKEDIN GRAVATAR) }

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
      it do
        is_expected
          .to validate_inclusion_of(:avatar_provider).in_array(valid_providers)
      end
    end

    it do
      is_expected
        .to enumerize(:gender).in(:unknown, :female, :male)
        .with_default(:unknown)
    end

    it do
      is_expected
        .to enumerize(:relationship)
        .in(:unknown, :single, :relationship, :engaged, :married, :complicated,
            :open, :widowed, :domestic, :civil).with_default(:unknown)
    end

    it ".create_with_omniauth" do
      expect(Socializer::Person).to respond_to(:create_with_omniauth)
    end

    context "#services" do
      let(:authentications_attributes) do
        { provider: "facebook", image_url: "http://facebook.com", uid: 1 }
      end

      let(:person) { create(:person, avatar_provider: "FACEBOOK") }

      before do
        person.authentications.create(authentications_attributes)
      end

      it { expect(person.services.to_sql).to include("!= 'identity'") }
      it { expect(person.services.count).to eq(1) }
      it "Socializer::Person#services should eq facebook" do
        expect(person.services.find_by(provider: "facebook").provider)
          .to eq("facebook")
      end
    end

    context "#circles" do
      let(:person) { build(:person_circles) }
      let(:circles) { person.activity_object.circles }
      it { expect(person.circles).to be_a(circles.class) }
      it { expect(person.circles).to eq(circles) }
    end

    context "#comments" do
      let(:person) { build(:person_comments) }
      let(:comments) { person.activity_object.comments }
      it { expect(person.comments).to be_a(comments.class) }
      it { expect(person.comments).to eq(comments) }
    end

    context "#groups" do
      let(:person) { build(:person_groups) }
      let(:groups) { person.activity_object.groups }
      it { expect(person.groups).to be_a(groups.class) }
      it { expect(person.groups).to eq(groups) }
    end

    context "#notes" do
      let(:person) { build(:person_notes) }
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
      let(:person) { build(:person_circles) }
      # TODO: Test return values
      it do
        expect(person.contacts)
          .to be_kind_of(ActiveRecord::Associations::CollectionProxy)
      end
    end

    context "#contact_of" do
      let(:person) { build(:person_circles) }
      # TODO: Test return values
      it { expect(person.contact_of).to be_kind_of(ActiveRecord::Relation) }
    end

    context "#likes and #likes?" do
      let(:liking_person) { create(:person) }
      let(:liked_activity_object) { create(:activity_object) }

      before do
        Activity::Services::Like
          .new(actor: liking_person,
               activity_object: liked_activity_object).call
      end

      it { expect(liking_person.likes.count.size).to eq(1) }
      it { expect(liking_person.likes?(liked_activity_object)).to be_truthy }
    end

    it "#pending_membership_invites" do
      expect(person).to respond_to(:pending_membership_invites)
    end

    context "accepts known avatar_provider" do
      it "when it is 'FACEBOOK'" do
        expect(build(:person, avatar_provider: "FACEBOOK")).to be_valid
      end

      it "when it is 'GRAVATAR'" do
        expect(build(:person, avatar_provider: "GRAVATAR")).to be_valid
      end

      it "when it is 'LINKEDIN'" do
        expect(build(:person, avatar_provider: "LINKEDIN")).to be_valid
      end

      it "when it is 'TWITTER'" do
        expect(build(:person, avatar_provider: "TWITTER")).to be_valid
      end
    end

    context "rejects unknown avatar_provider" do
      it "when it is 'IDENTITY'" do
        expect(build(:person, avatar_provider: "IDENTITY")).to be_invalid
      end

      it "when it is 'TEST'" do
        expect(build(:person, avatar_provider: "TEST")).to be_invalid
      end

      it "when it is 'DUMMY'" do
        expect(build(:person, avatar_provider: "DUMMY")).to be_invalid
      end

      it "when it is 'OTHER'" do
        expect(build(:person, avatar_provider: "OTHER")).to be_invalid
      end
    end
  end
end
