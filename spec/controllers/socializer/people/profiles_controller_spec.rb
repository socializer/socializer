require 'spec_helper'

module Socializer
  RSpec.describe People::ProfilesController, type: :controller do
    routes { Socializer::Engine.routes }

    # Create a user nad profile
    let(:user) { create(:socializer_person) }
    let(:valid_attributes) { { label: 'test', url: 'http://test.org' } }
    let(:profile) { user.profiles.create!(valid_attributes) }

    # Setting the current user
    before { cookies[:user_id] = user.guid }

    it { should use_before_action(:authenticate_user) }

    describe 'POST #create' do
      context 'with valid attributes' do
        it 'saves the new profile in the database' do
          expect { post :create, person_profile: valid_attributes, person_id: user }.to change(PersonProfile, :count).by(1)
        end

        it 'redirects to people#show' do
          post :create, person_profile: valid_attributes, person_id: user
          expect(response).to redirect_to user
        end
      end

      context 'with invalid attributes' do
        it 'is a pending example'
      end
    end

    describe 'PATCH #update' do
      context 'with valid attributes' do
        it 'redirects to people#show' do
          patch :update, id: profile, person_id: user, person_profile: { label: 'updated content' }
          expect(response).to redirect_to user
        end
      end

      context 'with invalid attributes' do
        it 'is a pending example'
      end
    end

    describe 'DELETE #destroy' do
      it 'deletes the profile' do
        profile
        expect { delete :destroy, id: profile, person_id: user }.to change(PersonProfile, :count).by(-1)
      end

      it 'redirects to people#show' do
        delete :destroy, id: profile, person_id: user
        expect(response).to redirect_to user
      end
    end
  end
end
