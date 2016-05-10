require "rails_helper"
include Socializer::Engine.routes.url_helpers

module Socializer
  RSpec.describe PersonDecorator, type: :decorator do
    let(:person) { create(:person) }
    let(:decorated_person) { PersonDecorator.new(person) }

    context "attributes" do
      context "birthdate" do
        context "not specified" do
          it { expect(decorated_person.birthdate).to be nil }
        end

        context "specified" do
          let(:person) do
            build(:person, birthdate: Time.zone.now - 10.years)
          end

          it do
            expect(decorated_person.birthdate)
              .to eq(person.birthdate.to_s(:long_ordinal))
          end
        end
      end

      context "gender" do
        it { expect(decorated_person.gender).to eq("Unknown") }
      end

      context "occupation" do
        context "when nil" do
          let(:message) { "What do you do?" }
          it { expect(decorated_person.occupation).to eq(message) }
        end

        context "when not nil" do
          let(:occupation) { "sleeping, eating, drinking" }
          let(:person) { create(:person, occupation: occupation) }

          it { expect(decorated_person.occupation).to eq(occupation) }
        end
      end

      context "other_names" do
        context "without a value" do
          let(:message) { "For example: maiden name, alternate spellings" }
          it { expect(decorated_person.other_names).to eq(message) }
        end

        context "with a value" do
          let(:other_name) { "Mr Scary" }
          let(:person) { create(:person, other_names: other_name) }

          it { expect(decorated_person.other_names).to eq(other_name) }
        end
      end

      context "relationship" do
        context "when unknown" do
          let(:message) { "Seeing anyone?" }
          it { expect(decorated_person.relationship).to eq(message) }
        end

        context "when not unknown" do
          let(:relationship) { "single" }
          let(:person) { create(:person, relationship: relationship) }

          it do
            expect(decorated_person.relationship).to eq(relationship.titleize)
          end
        end
      end

      context "skills" do
        context "when nil" do
          let(:message) { "What are your skills?" }
          it { expect(decorated_person.skills).to eq(message) }
        end

        context "when not nil" do
          let(:skills) { "sleeping, eating, drinking" }
          let(:person) { create(:person, skills: skills) }

          it { expect(decorated_person.skills).to eq(skills) }
        end
      end
    end

    context "#avatar_url" do
      context "when the provider is Facebook, LinkedIn, or Twitter" do
        let(:authentication_attributes) do
          { provider: provider.downcase,
            image_url: "http://#{provider.downcase}.com",
            uid: person.id }
        end

        let(:person) do
          create(:person, avatar_provider: provider)
        end

        context "it should be Facebook" do
          before do
            person.authentications.create(authentication_attributes)
          end

          let(:provider) { "FACEBOOK" }

          it do
            expect(decorated_person.avatar_url).to include(provider.downcase)
          end
        end

        context "it should be LinkedIn" do
          before do
            person.authentications.create(authentication_attributes)
          end

          let(:provider) { "LINKEDIN" }

          it do
            expect(decorated_person.avatar_url).to include(provider.downcase)
          end
        end

        context "it should be Twitter" do
          before do
            person.authentications.create(authentication_attributes)
          end

          let(:provider) { "TWITTER" }

          it do
            expect(decorated_person.avatar_url).to include(provider.downcase)
          end
        end
      end

      context "when the provider is gravatar" do
        let(:avatar_url) { "http://www.gravatar.com/avatar/" }
        it { expect(decorated_person.avatar_url).to include(avatar_url) }

        context "with a blank email" do
          let(:person) { build(:person, email: nil) }
          it { expect(decorated_person.avatar_url).to eq(nil) }
        end
      end
    end

    context "contacts_count" do
      context "without contacts" do
        it { expect(decorated_person.contacts_count).to eq("0 people") }
      end

      context "with contacts" do
        it "is pending"
      end
    end

    context "contact_of_count" do
      context "not a contact of anyone" do
        it { expect(decorated_person.contact_of_count).to eq("0 people") }
      end

      context "is a contact of someone" do
        it "is pending"
      end
    end

    context "image_tag_avatar" do
      let(:person) { create(:person) }

      context "with no image_url" do
        let(:result) { decorated_person.image_tag_avatar }

        it do
          expect(result).to have_selector("img[alt=Avatar][src*=gravatar]")
        end

        it { expect(result).to include(decorated_person.avatar_url) }
      end

      context "with the size argument" do
        context "with Width x Height" do
          let(:result) do
            decorated_person.image_tag_avatar(size: "50x100")
          end

          let(:selector) do
            "img[alt=Avatar][src*=gravatar][width='50'][height='100']"
          end

          it { expect(result).to have_selector(selector) }
        end

        context "with number" do
          let(:result) do
            decorated_person.image_tag_avatar(size: "100")
          end

          let(:selector) do
            "img[alt=Avatar][src*=gravatar][width='100'][height='100']"
          end

          it { expect(result).to have_selector(selector) }
        end
      end

      context "with css class" do
        let(:result) do
          decorated_person.image_tag_avatar(css_class: "img")
        end

        let(:selector) do
          "img[alt=Avatar][src*=gravatar][class='img']"
        end

        it { expect(result).to have_selector(selector) }
      end

      context "with the alt argument" do
        let(:result) do
          decorated_person.image_tag_avatar(alt: "Different Text")
        end

        let(:selector) do
          "img[alt='Different Text'][src*=gravatar]"
        end

        it { expect(result).to have_selector(selector) }
      end

      context "with the title argument" do
        let(:result) do
          decorated_person.image_tag_avatar(title: "Title Text")
        end

        let(:selector) do
          "img[alt='Avatar'][src*=gravatar][title='Title Text']"
        end

        it { expect(result).to have_selector(selector) }
      end
    end

    context "link_to_avatar" do
      let(:person) { create(:person) }
      let(:result) { decorated_person.link_to_avatar }

      let(:image_tag_avatar) do
        decorated_person.image_tag_avatar(title: decorated_person.display_name)
      end

      let(:person_activities_path) do
        helpers.person_activities_path(person_id: person.id)
      end

      it { expect(result).to have_link("", href: person_activities_path) }
      it { expect(result).to include(image_tag_avatar) }
    end

    context "looking_for" do
      context "with no looking_for attributes set" do
        let(:string) { "Who are you looking for?" }

        it { expect(decorated_person.looking_for).to eq(string) }
      end

      context "with looking_for_friends true" do
        let(:person) { create(:person, looking_for_friends: true) }
        let(:string) { "Friends<br>" }

        it { expect(decorated_person.looking_for).to eq(string) }
      end

      context "with looking_for_dating true" do
        let(:person) { create(:person, looking_for_dating: true) }
        let(:string) { "Dating<br>" }

        it { expect(decorated_person.looking_for).to eq(string) }
      end

      context "with looking_for_relationship true" do
        let(:person) { create(:person, looking_for_relationship: true) }
        let(:string) { "Relationship<br>" }

        it { expect(decorated_person.looking_for).to eq(string) }
      end

      context "with looking_for_networking true" do
        let(:person) { create(:person, looking_for_networking: true) }
        let(:string) { "Networking<br>" }

        it { expect(decorated_person.looking_for).to eq(string) }
      end

      context "with looking for friends and dating are true" do
        let(:person) do
          create(:person, looking_for_friends: true, looking_for_dating: true)
        end

        let(:string) { "Friends<br>Dating<br>" }

        it { expect(decorated_person.looking_for).to eq(string) }
      end
    end

    context "toolbar_stream_links" do
      let(:person) { create(:person) }

      context "with no circles or memberships" do
        it { expect(decorated_person.toolbar_stream_links).to eq(nil) }
      end

      context "with circles and no memberships" do
        before do
          AddDefaultCircles.call(person: person)
        end

        let(:result) { decorated_person.toolbar_stream_links }
        let(:li_count) { person.circles.count + 1 }

        it { expect(result.html_safe?).to be true }

        it do
          expect(result)
            .to have_link("Friends", href: "/circles/1/activities")
        end

        it do
          expect(result)
            .to have_link("Family", href: "/circles/2/activities")
        end

        it do
          expect(result)
            .to have_link("Acquaintances", href: "/circles/3/activities")
        end

        it do
          expect(result)
            .to have_link("Following", href: "/circles/4/activities")
        end

        it do
          expect(result)
            .not_to have_link("Group", href: "/groups/1/activities")
        end

        it do
          expect(result).to have_selector("li", count: li_count)
        end

        it do
          # i18n-tasks-use t("socializer.shared.toolbar.more")
          expect(result)
            .to have_link(t("socializer.shared.toolbar.more"), href: "#")
        end

        it do
          expect(result).to have_selector("li.dropdown")
        end

        it do
          expect(result)
            .to have_selector("a.dropdown-toggle[data-toggle='dropdown']")
        end

        it do
          expect(result).to have_selector("ul.dropdown-menu")
        end
      end

      context "with no circles, but with memberships" do
        before do
          AddDefaultCircles.call(person: person)

          create(
            :group,
            author_id: person.id,
            display_name: "Group")
        end

        let(:result) { decorated_person.toolbar_stream_links }
        let(:li_count) { person.circles.count + person.groups.count + 1 }

        it { expect(result.html_safe?).to be true }

        it do
          expect(result)
            .to have_link("Friends", href: "/circles/1/activities")
        end

        it do
          expect(result).to have_link("Family", href: "/circles/2/activities")
        end

        it do
          expect(result)
            .to have_link("Acquaintances", href: "/circles/3/activities")
        end

        it do
          expect(result)
            .to have_link("Following", href: "/circles/4/activities")
        end

        it do
          expect(result).to have_link("Group", href: "/groups/1/activities")
        end

        it { expect(result).to have_selector("li", count: li_count) }

        it do
          # i18n-tasks-use t("socializer.shared.toolbar.more")
          expect(result)
            .to have_link(t("socializer.shared.toolbar.more"), href: "#")
        end

        it do
          expect(result).to have_selector("li.dropdown")
        end

        it do
          expect(result)
            .to have_selector("a.dropdown-toggle[data-toggle='dropdown']")
        end

        it do
          expect(result).to have_selector("ul.dropdown-menu")
        end
      end
    end
  end
end
