require 'rails_helper'

module Socializer
  RSpec.describe AudienceListsController, type: :controller do
    routes { Socializer::Engine.routes }

    # Create a user
    let(:user) { create(:socializer_person) }

    # Setting the current user
    before { cookies[:user_id] = user.guid }

    describe 'GET #index' do
      before :each do
        get :index, format: :json
      end

      context 'returns default values' do
        let(:json) { JSON.parse(response.body) }

        it { expect(json.count).to eq(2) }

        it 'public' do
          expect(json.first['id']).to match('public')
          expect(json.first['name']).to match('Public')
          expect(json.first['icon']).to match('fa-globe')
        end

        it 'circles' do
          expect(json.last['id']).to match('circles')
          expect(json.last['name']).to match('Circles')
          expect(json.last['icon']).to match('fa-google-circles')
        end
      end

      it 'returns http success' do
        expect(response).to have_http_status(:success)
      end
    end

  end
end
