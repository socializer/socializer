require 'rails_helper'

module Socializer
  RSpec.describe ActivityObjectDecorator, type: :decorator do
    let(:activity_object) { create(:socializer_activity_object) }
    let(:decorated_activity_object) { ActivityObjectDecorator.new(activity_object) }

    context 'link_to_like_or_unlike' do
      context 'to return nil when no current_user' do
        it { expect(decorated_activity_object.link_to_like_or_unlike(nil)).to eq(nil) }
      end

      context 'with current_user' do
        let(:person) { create(:socializer_person) }
        let(:result) { decorated_activity_object.link_to_like_or_unlike(person) }

        context 'does not like' do
          let(:url) { stream_like_path(activity_object) }

          it { expect(result).to have_link('', href: url) }
          it { expect(result).to have_selector("a.btn.btn-default [data-method='post'] [title=#{t('socializer.shared.like')}]") }
        end

        context 'does like' do
          before { activity_object.like!(person) }
          let(:url) { stream_unlike_path(activity_object) }

          it { expect(result).to have_link('', href: url) }
          it { expect(result).to have_selector("a.btn.btn-danger [data-method='delete'] [title=#{t('socializer.shared.unlike')}]") }
        end
      end
    end
  end
end
