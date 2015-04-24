require 'rails_helper'

module Socializer
  RSpec.describe TiesController, type: :controller do
    routes { Socializer::Engine.routes }

    # Create a user, a circle, a tie, and valid_attributes
    let(:user) { create(:socializer_person) }
    let(:circle) { create(:socializer_circle) }
    let(:tie) { create(:socializer_tie, activity_contact: user.activity_object, circle: circle) }
    let(:valid_attributes) { { tie: { circle_id: circle.id, contact_id: user.activity_object.id } } }

    # Setting the current user
    before { cookies[:user_id] = user.guid }

    describe 'POST #create' do
      before :each do
        @request.env['HTTP_ACCEPT'] = 'application/javascript'
      end

      context 'with valid attributes' do
        it 'saves the new group in the database' do
          expect { post :create, valid_attributes }.to change(Tie, :count).by(1)
        end

        it 'returns http ok' do
          post :create, valid_attributes
          expect(response).to have_http_status(:ok)
        end
      end

      context 'with invalid attributes' do
        it 'is a pending example'
      end
    end

    describe 'DELETE #destroy' do
      it 'deletes the tie' do
        tie
        expect { delete :destroy, id: tie }.to change(Tie, :count).by(-1)
      end

      context 'check the variables and redirect' do
        before :each do
          delete :destroy, id: tie
        end

        it 'assigns @tie' do
          expect(assigns(:tie)).to eq tie
        end

        it 'assigns @circle' do
          expect(assigns(:circle)).to eq circle
        end

        it 'redirects to circles#show' do
          expect(response).to redirect_to circle
        end
      end
    end
  end
end
