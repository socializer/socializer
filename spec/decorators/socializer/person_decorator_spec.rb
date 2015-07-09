require "rails_helper"
include Socializer::Engine.routes.url_helpers

module Socializer
  RSpec.describe PersonDecorator, type: :decorator do
    let(:person) { build(:socializer_person) }
    let(:decorated_person) { PersonDecorator.new(person) }

    context "#avatar_url" do
      context "when the provider is Facebook, LinkedIn, or Twitter" do
        let(:authentication_attributes) do
          { provider: provider.downcase,
            image_url: "http://#{provider.downcase}.com",
            uid: person.id
          }
        end

        let(:person) do
          create(:socializer_person, avatar_provider: provider)
        end

        let(:decorated_person) { PersonDecorator.new(person) }

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
          let(:person) { build(:socializer_person, email: nil) }
          let(:decorated_person) { PersonDecorator.new(person) }
          it { expect(decorated_person.avatar_url).to eq(nil) }
        end
      end
    end

    context "birthdate" do
      context "not specified" do
        it { expect(decorated_person.birthdate).to be nil }
      end

      context "specified" do
        let(:person) do
          build(:socializer_person, birthdate: Time.zone.now - 10.years)
        end

        it do
          expect(decorated_person.birthdate)
          .to eq(person.birthdate.to_s(:long_ordinal))
        end
      end
    end

    context "image_tag_avatar" do
      let(:person) { create(:socializer_person) }
      let(:decorated_person) { PersonDecorator.new(person) }

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
      let(:person) { create(:socializer_person) }
      let(:decorated_person) { PersonDecorator.new(person) }
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

    context "toolbar_stream_links" do
      let(:person) { create(:socializer_person) }
      let(:decorated_person) { PersonDecorator.new(person) }

      context "with no circles or memberships" do
        it { expect(decorated_person.toolbar_stream_links).to eq(nil) }
      end

      context "with circles and no memberships" do
        before do
          AddDefaultCircles.perform(person: person)
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
          AddDefaultCircles.perform(person: person)

          create(
            :socializer_group,
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
