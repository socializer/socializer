require 'rails_helper'
include Socializer::Engine.routes.url_helpers

module Socializer
  RSpec.describe PersonDecorator, type: :decorator do
    let(:person) { build(:socializer_person) }
    let(:decorated_person) { PersonDecorator.new(person) }

    context '#avatar_url' do
      it 'when the provider is Facebook, LinkedIn, or Twitter' do
        %w( FACEBOOK LINKEDIN TWITTER ).each do |provider|
          person = create(:socializer_person, avatar_provider: provider)
          person.authentications.create(provider: provider.downcase, image_url: "http://#{provider.downcase}.com")
          decorated_person = PersonDecorator.new(person)

          expect(decorated_person.avatar_url).to include(provider.downcase)
        end
      end

      context 'when the provider is gravatar' do
        it { expect(decorated_person.avatar_url).to include('http://www.gravatar.com/avatar/') }

        context 'with a blank email' do
          let(:person) { build(:socializer_person, email: nil) }
          let(:decorated_person) { PersonDecorator.new(person) }
          it { expect(decorated_person.avatar_url).to eq(nil) }
        end
      end
    end

    context 'birthdate' do
      context 'not specified' do
        it { expect(decorated_person.birthdate).to be nil }
      end

      context 'specified' do
        let(:person) { build(:socializer_person, birthdate: Time.zone.now - 10.years) }

        it { expect(decorated_person.birthdate).to eq(person.birthdate.to_s(:long_ordinal)) }
      end
    end

    context 'image_tag_avatar' do
      let(:person) { create(:socializer_person) }
      let(:decorated_person) { PersonDecorator.new(person) }

      context 'with no image_url' do
        let(:result) { decorated_person.image_tag_avatar }
        it { expect(result).to have_selector('img[alt=Avatar][src*=gravatar]') }
        it { expect(result).to include(decorated_person.avatar_url) }
      end

      context 'with the size argument' do
        context 'with Width x Height' do
          let(:result) { decorated_person.image_tag_avatar(size: '50x100') }
          it { expect(result).to have_selector("img[alt=Avatar][src*=gravatar][width='50'][height='100']") }
        end

        context 'with number' do
          let(:result) { decorated_person.image_tag_avatar(size: '100') }
          it { expect(result).to have_selector("img[alt=Avatar][src*=gravatar][width='100'][height='100']") }
        end
      end

      context 'with css class' do
        let(:result) { decorated_person.image_tag_avatar(css_class: 'img') }
        it { expect(result).to have_selector("img[alt=Avatar][src*=gravatar][class='img']") }
      end

      context 'with the alt argument' do
        let(:result) { decorated_person.image_tag_avatar(alt: 'Different Text') }
        it { expect(result).to have_selector("img[alt='Different Text'][src*=gravatar]") }
      end

      context 'with the title argument' do
        let(:result) { decorated_person.image_tag_avatar(title: 'Title Text') }
        it { expect(result).to have_selector("img[alt='Avatar'][src*=gravatar][title='Title Text']") }
      end
    end

    context 'link_to_avatar' do
      let(:person) { create(:socializer_person) }
      let(:decorated_person) { PersonDecorator.new(person) }
      let(:result) { decorated_person.link_to_avatar }

      it { expect(result).to have_link('', href: helpers.stream_path(provider: :people, id: person.id)) }
      it { expect(result).to include(decorated_person.image_tag_avatar(title: decorated_person.display_name)) }
    end

    context 'toolbar_stream_links' do
      let(:person) { create(:socializer_person) }
      let(:decorated_person) { PersonDecorator.new(person) }

      context 'with no circles or memberships' do
        it { expect(decorated_person.toolbar_stream_links).to eq(nil) }
      end

      context 'with circles and no memberships' do
        before do
          AddDefaultCircles.perform(person: person)
        end

        let(:result) { decorated_person.toolbar_stream_links }
        let(:li_count) { person.circles.count + 1 }

        it { expect(result.html_safe?).to be true }
        it { expect(result).to have_link('Friends', href: '/stream/circles/1') }
        it { expect(result).to have_link('Family', href: '/stream/circles/2') }
        it { expect(result).to have_link('Acquaintances', href: '/stream/circles/3') }
        it { expect(result).to have_link('Following', href: '/stream/circles/4') }
        it { expect(result).not_to have_link('Group', href: '/stream/groups/1') }

        it { expect(result).to have_selector('li', count: li_count) }
        # TODO: Should be able to use t('.more')
        it { expect(result).to have_link(t('socializer.shared.toolbar.more'), href: '#') }
        it { expect(result).to have_selector('li.dropdown') }
        it { expect(result).to have_selector("a.dropdown-toggle[data-toggle='dropdown']") }
        it { expect(result).to have_selector('ul.dropdown-menu') }
      end

      context 'with no circles, but with memberships' do
        before do
          AddDefaultCircles.perform(person: person)
          create(:socializer_group, author_id: person.id, display_name: 'Group')
        end

        let(:result) { decorated_person.toolbar_stream_links }
        let(:li_count) { person.circles.count + person.groups.count + 1 }

        it { expect(result.html_safe?).to be true }
        it { expect(result).to have_link('Friends', href: '/stream/circles/1') }
        it { expect(result).to have_link('Family', href: '/stream/circles/2') }
        it { expect(result).to have_link('Acquaintances', href: '/stream/circles/3') }
        it { expect(result).to have_link('Following', href: '/stream/circles/4') }
        it { expect(result).to have_link('Group', href: '/stream/groups/1') }

        it { expect(result).to have_selector('li', count: li_count) }
        # TODO: Should be able to use t('.more')
        it { expect(result).to have_link(t('socializer.shared.toolbar.more'), href: '#') }
        it { expect(result).to have_selector('li.dropdown') }
        it { expect(result).to have_selector("a.dropdown-toggle[data-toggle='dropdown']") }
        it { expect(result).to have_selector('ul.dropdown-menu') }
      end
    end
  end
end
