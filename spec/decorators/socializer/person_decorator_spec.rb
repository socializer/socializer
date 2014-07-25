require 'rails_helper'
include Socializer::Engine.routes.url_helpers

module Socializer
  RSpec.describe PersonDecorator, type: :decorator do
    let(:person) { build(:socializer_person) }
    let(:decorated_person) { PersonDecorator.new(person) }

    context 'birthdate' do
      context 'not specified' do
        it { expect(decorated_person.birthdate).to be nil }
      end

      context 'specified' do
        let(:person) { build(:socializer_person, birthdate: Time.now - 10.years) }

        it { expect(decorated_person.birthdate).to eq(person.birthdate.to_s(:long_ordinal)) }
      end
    end

    context 'image_tag_avatar' do
      let(:person) { create(:socializer_person) }
      let(:decorated_person) { PersonDecorator.new(person) }

      context 'with no image_url' do
        let(:result) { decorated_person.image_tag_avatar }
        it { expect(result).to have_selector('img [alt=Avatar] [src*=gravatar]') }
      end

      context 'with the size argument' do
        context 'with Width x Height' do
          let(:result) { decorated_person.image_tag_avatar(size: '50x100') }
          it { expect(result).to have_selector("img [alt=Avatar] [src*=gravatar] [width='50'] [height='100']") }
        end

        context 'with number' do
          let(:result) { decorated_person.image_tag_avatar(size: '100') }
          it { expect(result).to have_selector("img [alt=Avatar] [src*=gravatar] [width='100'] [height='100']") }
        end
      end

      context 'with css class' do
        let(:result) { decorated_person.image_tag_avatar(css_class: 'img') }
        it { expect(result).to have_selector("img [alt=Avatar] [src*=gravatar] [class='img']") }
      end

      context 'with the alt argument' do
        let(:result) { decorated_person.image_tag_avatar(alt: 'Different Text') }
        it { expect(result).to have_selector("img [alt='Different Text'] [src*=gravatar]") }
      end
    end

    context 'toolbar_stream_links' do
      let(:person) { create(:socializer_person) }
      let(:decorated_person) { PersonDecorator.new(person) }

      context 'with no circles or memberships' do
        it { expect(decorated_person.toolbar_stream_links).to eq(nil) }
      end

      context 'with circles and no memberships' do
        before do
          person.add_default_circles
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
        it { expect(result).to have_selector("a.dropdown-toggle [data-toggle='dropdown']") }
        it { expect(result).to have_selector('ul.dropdown-menu') }
      end

      context 'with no circles, but with memberships' do
        before do
          person.add_default_circles
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
        it { expect(result).to have_selector("a.dropdown-toggle [data-toggle='dropdown']") }
        it { expect(result).to have_selector('ul.dropdown-menu') }
      end
    end
  end
end
