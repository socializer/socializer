require 'rails_helper'

module Socializer
  RSpec.describe ApplicationController, type: :controller do
    controller do
      def index
        render text: 'Hello'
      end
    end

    let(:user) { create(:socializer_person) }

    it { should use_before_action(:set_locale) }
    it { should_not use_before_action(:authenticate_user) }

    # Setting the current user
    before { cookies[:user_id] = user.guid }

    describe '#set_locale' do
      context 'language set on the person' do
        before :each do
          get :index
        end

        let(:user) { create(:socializer_person, :english) }
        it { expect(I18n.locale.to_s).to eq(user.language) }
      end

      context "language set in request.env['HTTP_ACCEPT_LANGUAGE']" do
        before :each do
          request.env['HTTP_ACCEPT_LANGUAGE'] = 'en'
          get :index
        end

        let(:language) { request.env['HTTP_ACCEPT_LANGUAGE'] }
        it { expect(I18n.locale.to_s).to eq(language) }
      end
    end
  end
end
