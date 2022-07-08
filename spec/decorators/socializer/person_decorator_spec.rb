# frozen_string_literal: true

require "rails_helper"
include Socializer::Engine.routes.url_helpers

module Socializer
  RSpec.describe PersonDecorator, type: :decorator do
    let(:person) { create(:person) }
    let(:decorated_person) { described_class.new(person) }

    context "with attributes" do
      describe "birthdate" do
        context "when not specified" do
          specify { expect(decorated_person.birthdate).to be_nil }
        end

        context "when specified" do
          let(:person) do
            build(:person, birthdate: 10.years.ago)
          end

          specify do
            expect(decorated_person.birthdate)
              .to eq(person.birthdate.to_fs(:long_ordinal))
          end
        end
      end

      describe "gender" do
        specify { expect(decorated_person.gender).to eq("Unknown") }
      end

      describe "occupation" do
        context "when nil" do
          let(:message) { "What do you do?" }

          specify { expect(decorated_person.occupation).to eq(message) }
        end

        context "when not nil" do
          let(:occupation) { "sleeping, eating, drinking" }
          let(:person) { create(:person, occupation:) }

          specify { expect(decorated_person.occupation).to eq(occupation) }
        end
      end

      describe "other_names" do
        context "when no value" do
          let(:message) { "For example: maiden name, alternate spellings" }

          specify { expect(decorated_person.other_names).to eq(message) }
        end

        context "with a value" do
          let(:other_name) { "Mr Scary" }
          let(:person) { create(:person, other_names: other_name) }

          specify { expect(decorated_person.other_names).to eq(other_name) }
        end
      end

      describe "relationship" do
        context "when unknown" do
          let(:message) { "Seeing anyone?" }

          specify { expect(decorated_person.relationship).to eq(message) }
        end

        context "when not unknown" do
          let(:relationship) { "single" }
          let(:person) { create(:person, relationship:) }

          specify do
            expect(decorated_person.relationship).to eq(relationship.titleize)
          end
        end
      end

      describe "skills" do
        context "when nil" do
          let(:message) { "What are your skills?" }

          specify { expect(decorated_person.skills).to eq(message) }
        end

        context "when not nil" do
          let(:skills) { "sleeping, eating, drinking" }
          let(:person) { create(:person, skills:) }

          specify { expect(decorated_person.skills).to eq(skills) }
        end
      end
    end

    describe "#avatar_url" do
      context "when the provider is Facebook, LinkedIn, or Twitter" do
        let(:authentication_attributes) do
          { provider: provider.downcase,
            image_url: "http://#{provider.downcase}.com",
            uid: person.id }
        end

        let(:person) do
          create(:person, avatar_provider: provider)
        end

        context "when it should be Facebook" do
          before do
            person.authentications.create(authentication_attributes)
          end

          let(:provider) { "FACEBOOK" }

          specify do
            expect(decorated_person.avatar_url).to include(provider.downcase)
          end
        end

        context "when it should be LinkedIn" do
          before do
            person.authentications.create(authentication_attributes)
          end

          let(:provider) { "LINKEDIN" }

          specify do
            expect(decorated_person.avatar_url).to include(provider.downcase)
          end
        end

        context "when it should be Twitter" do
          before do
            person.authentications.create(authentication_attributes)
          end

          let(:provider) { "TWITTER" }

          specify do
            expect(decorated_person.avatar_url).to include(provider.downcase)
          end
        end
      end

      context "when the provider is gravatar" do
        let(:avatar_url) { "http://www.gravatar.com/avatar/" }

        specify { expect(decorated_person.avatar_url).to include(avatar_url) }

        context "with a blank email" do
          let(:person) { build(:person, email: nil) }

          specify { expect(decorated_person.avatar_url).to be_nil }
        end
      end
    end

    describe "contacts_count" do
      context "when no contacts" do
        specify { expect(decorated_person.contacts_count).to eq("0 people") }
      end

      context "with contacts" do
        it "is pending" do
          pending "it has not been implemented yet."
          raise
        end
      end
    end

    describe "contact_of_count" do
      context "when not a contact of anyone" do
        specify { expect(decorated_person.contact_of_count).to eq("0 people") }
      end

      context "when a contact of someone" do
        it "is pending" do
          pending "it has not been implemented yet."
          raise
        end
      end
    end

    describe "image_tag_avatar" do
      let(:person) { create(:person) }

      context "with no image_url" do
        let(:result) { decorated_person.image_tag_avatar }

        specify do
          expect(result).to have_selector("img[alt=Avatar][src*=gravatar]")
        end

        specify { expect(result).to include(decorated_person.avatar_url) }
      end

      context "with the size argument" do
        context "with Width x Height" do
          let(:result) do
            decorated_person.image_tag_avatar(size: "50x100")
          end

          let(:selector) do
            "img[alt=Avatar][src*=gravatar][width='50'][height='100']"
          end

          specify { expect(result).to have_selector(selector) }
        end

        context "with number" do
          let(:result) do
            decorated_person.image_tag_avatar(size: "100")
          end

          let(:selector) do
            "img[alt=Avatar][src*=gravatar][width='100'][height='100']"
          end

          specify { expect(result).to have_selector(selector) }
        end
      end

      context "with css class" do
        let(:result) do
          decorated_person.image_tag_avatar(css_class: "img")
        end

        let(:selector) do
          "img[alt=Avatar][src*=gravatar][class='img']"
        end

        specify { expect(result).to have_selector(selector) }
      end

      context "with the alt argument" do
        let(:result) do
          decorated_person.image_tag_avatar(alt: "Different Text")
        end

        let(:selector) do
          "img[alt='Different Text'][src*=gravatar]"
        end

        specify { expect(result).to have_selector(selector) }
      end

      context "with the title argument" do
        let(:result) do
          decorated_person.image_tag_avatar(title: "Title Text")
        end

        let(:selector) do
          "img[alt='Avatar'][src*=gravatar][title='Title Text']"
        end

        specify { expect(result).to have_selector(selector) }
      end
    end

    describe "link_to_avatar" do
      let(:person) { create(:person) }
      let(:result) { decorated_person.link_to_avatar }

      let(:image_tag_avatar) do
        decorated_person.image_tag_avatar(title: decorated_person.display_name)
      end

      let(:person_activities_path) do
        helpers.person_activities_path(person_id: person.id)
      end

      specify { expect(result).to have_link("", href: person_activities_path) }
      specify { expect(result).to include(image_tag_avatar) }
    end

    describe "looking_for" do
      context "with no looking_for attributes set" do
        let(:string) { "Who are you looking for?" }

        specify { expect(decorated_person.looking_for).to eq(string) }
      end

      context "with looking_for_friends true" do
        let(:person) { create(:person, looking_for_friends: true) }
        let(:string) { "Friends<br>" }

        specify { expect(decorated_person.looking_for).to eq(string) }
      end

      context "with looking_for_dating true" do
        let(:person) { create(:person, looking_for_dating: true) }
        let(:string) { "Dating<br>" }

        specify { expect(decorated_person.looking_for).to eq(string) }
      end

      context "with looking_for_relationship true" do
        let(:person) { create(:person, looking_for_relationship: true) }
        let(:string) { "Relationship<br>" }

        specify { expect(decorated_person.looking_for).to eq(string) }
      end

      context "with looking_for_networking true" do
        let(:person) { create(:person, looking_for_networking: true) }
        let(:string) { "Networking<br>" }

        specify { expect(decorated_person.looking_for).to eq(string) }
      end

      context "with looking for friends and dating are true" do
        let(:person) do
          create(:person, looking_for_friends: true, looking_for_dating: true)
        end

        let(:string) { "Friends<br>Dating<br>" }

        specify { expect(decorated_person.looking_for).to eq(string) }
      end
    end

    describe "toolbar_stream_links" do
      let(:person) { create(:person) }

      let(:friends) { Circle.with_display_name(name: "Friends").first }
      let(:family) { Circle.with_display_name(name: "Family").first }
      let(:acquaintances) do
        Circle.with_display_name(name: "Acquaintances").first
      end
      let(:following) { Circle.with_display_name(name: "Following").first }
      let(:group) { Group.with_display_name(name: "Group").first }

      let(:friends_url) { circle_activities_path(friends.id) }
      let(:family_url) { circle_activities_path(family.id) }
      let(:acquaintances_url) { circle_activities_path(acquaintances.id) }
      let(:following_url) { circle_activities_path(following.id) }
      let(:group_url) { group_activities_path(group&.id) }

      context "with no circles or memberships" do
        specify { expect(decorated_person.toolbar_stream_links).to be_nil }
      end

      context "with circles and no memberships" do
        before do
          AddDefaultCircles.call(person:)
        end

        let(:result) { decorated_person.toolbar_stream_links }
        let(:li_count) { person.circles.count + 1 }

        specify { expect(result.html_safe?).to be true }

        specify do
          expect(result)
            .to have_link("Friends", href: friends_url)
        end

        specify do
          expect(result)
            .to have_link("Family", href: family_url)
        end

        specify do
          expect(result)
            .to have_link("Acquaintances", href: acquaintances_url)
        end

        specify do
          expect(result)
            .to have_link("Following", href: following_url)
        end

        specify do
          expect(result)
            .not_to have_link("Group", href: "/groups/1/activities")
        end

        specify do
          expect(result).to have_selector("li", count: li_count)
        end

        specify do
          # i18n-tasks-use t("socializer.shared.toolbar.more")
          expect(result)
            .to have_link(t("socializer.shared.toolbar.more"),
                          href: "", class: "dropdown-toggle")
        end

        specify do
          expect(result).to have_selector("li.dropdown")
        end

        # specify do
        #     .to have_selector("a.dropdown-toggle[data-toggle='dropdown']")
        # end

        specify do
          expect(result).to have_selector("ul.dropdown-menu")
        end
      end

      context "with no circles, but with memberships" do
        before do
          AddDefaultCircles.call(person:)

          create(:group, author_id: person.id, display_name: "Group")
        end

        let(:result) { decorated_person.toolbar_stream_links }
        let(:li_count) { person.circles.count + person.groups.count + 1 }

        specify { expect(result.html_safe?).to be true }

        specify do
          expect(result)
            .to have_link("Friends", href: friends_url)
        end

        specify do
          expect(result)
            .to have_link("Family", href: family_url)
        end

        specify do
          expect(result)
            .to have_link("Acquaintances", href: acquaintances_url)
        end

        specify do
          expect(result)
            .to have_link("Following", href: following_url)
        end

        specify do
          expect(result)
            .to have_link("Group", href: group_url)
        end

        specify { expect(result).to have_selector("li", count: li_count) }

        specify do
          # i18n-tasks-use t("socializer.shared.toolbar.more")
          expect(result)
            .to have_link(t("socializer.shared.toolbar.more"),
                          href: "", class: "dropdown-toggle")
        end

        specify do
          expect(result).to have_selector("li.dropdown")
        end

        # specify do
        #   expect(result)
        #     .to have_selector("a.dropdown-toggle[data-toggle='dropdown']")
        # end

        specify do
          expect(result).to have_selector("ul.dropdown-menu")
        end
      end
    end
  end
end
