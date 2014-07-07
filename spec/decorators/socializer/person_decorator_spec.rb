require 'rails_helper'
include Socializer::Engine.routes.url_helpers

module Socializer
  RSpec.describe PersonDecorator, :draper_with_helpers, type: :decorator do
    let(:person) { build(:socializer_person) }
    let(:decorated_person) { PersonDecorator.new(person) }

    context 'birthdate' do
      context 'not specified' do
        it { expect(decorated_person.birthday).to be nil }
      end

      context 'specified' do
        let(:person) { build(:socializer_person, birthdate: Time.now - 10.years) }

        it { expect(decorated_person.birthday).to eq(person.birthdate.to_s(:long_ordinal)) }
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

        it { expect(result.html_safe?).to be true }
        it { expect(result).to have_link('Friends', href: '/stream/circles/1') }
        it { expect(result).to have_link('Family', href: '/stream/circles/2') }
        it { expect(result).to have_link('Acquaintances', href: '/stream/circles/3') }
        it { expect(result).to have_link('Following', href: '/stream/circles/4') }
        it { expect(result).not_to have_link('Group', href: '/stream/groups/1') }

        it { expect(result).to have_link('More', href: '#') }
        it { expect(result).to have_selector('li.dropdown') }
        it { expect(result).to have_selector('a.dropdown-toggle') }
        it { expect(result).to have_selector('ul.dropdown-menu') }
      end

      context 'with no circles, but with memberships' do
        before do
          person.add_default_circles
          create(:socializer_group, author_id: person.id, name: 'Group')
        end

        let(:result) { decorated_person.toolbar_stream_links }

        it { expect(result.html_safe?).to be true }
        it { expect(result).to have_link('Friends', href: '/stream/circles/1') }
        it { expect(result).to have_link('Family', href: '/stream/circles/2') }
        it { expect(result).to have_link('Acquaintances', href: '/stream/circles/3') }
        it { expect(result).to have_link('Following', href: '/stream/circles/4') }
        it { expect(result).to have_link('Group', href: '/stream/groups/1') }

        it { expect(result).to have_link('More', href: '#') }
        it { expect(result).to have_selector('li.dropdown') }
        it { expect(result).to have_selector('a.dropdown-toggle') }
        it { expect(result).to have_selector('ul.dropdown-menu') }
      end
    end
  end
end
