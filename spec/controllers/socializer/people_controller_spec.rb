require 'rails_helper'

module Socializer
  RSpec.describe PeopleController, type: :controller do
    routes { Socializer::Engine.routes }

    # Create a user
    let(:user) { create(:socializer_person) }

    # Setting the current user
    before { cookies[:user_id] = user.guid }

    describe 'GET #index' do
      before :each do
        get :index
      end

      it 'assigns @people' do
        expect(assigns(:people)).to match_array([user])
      end

      it 'renders the :index template' do
        expect(response).to render_template :index
      end
    end

    describe 'GET #show' do
      before :each do
        get :show, id: user
      end

      it 'assigns @person' do
        expect(assigns(:person)).to eq user
      end

      it 'renders the show template' do
        expect(response).to render_template :show
      end
    end

    describe 'GET #edit' do
      before :each do
        get :edit, id: user
      end

      it 'assigns @person' do
        expect(assigns(:person)).to eq user
      end

      it 'renders the :edit template' do
        expect(response).to render_template :edit
      end
    end

    describe 'PATCH #update' do
      context 'with valid attributes' do
        it 'redirects to /people#show ' do
          patch :update, id: user, person: { tagline: 'This is a tagline' }
          expect(response).to redirect_to user
        end
      end

      context 'with invalid attributes' do
        it 'is a pending example'
      end
    end
  end
end
