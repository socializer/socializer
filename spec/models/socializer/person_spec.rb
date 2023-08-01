# frozen_string_literal: true

require "rails_helper"

module Socializer
  RSpec.describe Person do
    let(:person) { build(:person) }
    let(:valid_providers) { %w[TWITTER FACEBOOK LINKEDIN GRAVATAR] }

    it "has a valid factory" do
      expect(person).to be_valid
    end

    context "with relationships" do
      specify { is_expected.to have_one(:activity_object) }
      specify { is_expected.to have_many(:authentications) }
      specify { is_expected.to have_many(:addresses) }
      specify { is_expected.to have_many(:contributions) }
      specify { is_expected.to have_many(:educations) }
      specify { is_expected.to have_many(:employments) }
      specify { is_expected.to have_many(:links) }
      specify { is_expected.to have_many(:phones) }
      specify { is_expected.to have_many(:places) }
    end

    context "with validations" do
      specify do
        expect(person)
          .to validate_inclusion_of(:avatar_provider).in_array(valid_providers)
      end
    end

    specify do
      expect(person).to enumerize(:gender)
        .in(:unknown, :female, :male).with_default(:unknown)
        .with_predicates(true)
        .with_scope(true)
    end

    specify do
      expect(person).to enumerize(:relationship)
        .in(:unknown, :single, :relationship, :engaged, :married, :complicated,
            :open, :widowed, :domestic, :civil)
        .with_default(:unknown)
        .with_predicates(true).with_scope(true)
    end

    it ".create_with_omniauth" do
      expect(described_class).to respond_to(:create_with_omniauth)
    end

    describe "#services" do
      let(:authentications_attributes) do
        { provider: "facebook", image_url: "http://facebook.com", uid: 1 }
      end

      let(:person) { create(:person, avatar_provider: "FACEBOOK") }

      before do
        person.authentications.create(authentications_attributes)
      end

      specify { expect(person.services.to_sql).to include("!= 'identity'") }
      specify { expect(person.services.count).to eq(1) }

      it "Socializer::Person#services should eq facebook" do
        expect(person.services.find_by(provider: "facebook").provider)
          .to eq("facebook")
      end
    end

    describe "#circles" do
      let(:person) { build(:person_circles) }
      let(:circles) { person.activity_object.circles }

      specify { expect(person.circles).to be_a(circles.class) }
      specify { expect(person.circles).to eq(circles) }
    end

    describe "#comments" do
      let(:person) { build(:person_comments) }
      let(:comments) { person.activity_object.comments }

      specify { expect(person.comments).to be_a(comments.class) }
      specify { expect(person.comments).to eq(comments) }
    end

    describe "#groups" do
      let(:person) { build(:person_groups) }
      let(:groups) { person.activity_object.groups }

      specify { expect(person.groups).to be_a(groups.class) }
      specify { expect(person.groups).to eq(groups) }
    end

    describe "#notes" do
      let(:person) { build(:person_notes) }
      let(:notes) { person.activity_object.notes }

      specify { expect(person.notes).to be_a(notes.class) }
      specify { expect(person.notes).to eq(notes) }
    end

    it "#memberships" do
      expect(person).to respond_to(:memberships)
    end

    it "#notifications" do
      expect(person).to respond_to(:received_notifications)
    end

    describe "#contacts" do
      let(:person) { build(:person_circles) }

      # TODO: Test return values
      specify do
        expect(person.contacts)
          .to be_a(ActiveRecord::Associations::CollectionProxy)
      end
    end

    describe "#contact_of" do
      let(:person) { build(:person_circles) }

      # TODO: Test return values
      specify do
        expect(person.contact_of).to be_a(ActiveRecord::Relation)
      end
    end

    describe "#likes and #likes?" do
      let(:liking_person) { create(:person) }
      let(:liked_activity_object) { create(:activity_object) }

      before do
        Activity::Services::Like
          .new(actor: liking_person)
          .call(activity_object: liked_activity_object)
      end

      specify { expect(liking_person.likes.count.size).to eq(1) }
      specify { expect(liking_person).to be_likes(liked_activity_object) }
    end

    it "#pending_membership_invites" do
      expect(person).to respond_to(:pending_membership_invites)
    end

    context "when it accepts known avatar_provider" do
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

    context "when it rejects unknown avatar_provider" do
      it "when it is 'IDENTITY'" do
        expect(build(:person, avatar_provider: "IDENTITY")).not_to be_valid
      end

      it "when it is 'TEST'" do
        expect(build(:person, avatar_provider: "TEST")).not_to be_valid
      end

      it "when it is 'DUMMY'" do
        expect(build(:person, avatar_provider: "DUMMY")).not_to be_valid
      end

      it "when it is 'OTHER'" do
        expect(build(:person, avatar_provider: "OTHER")).not_to be_valid
      end
    end
  end
end
