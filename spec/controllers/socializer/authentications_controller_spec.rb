require 'rails_helper'

module Socializer
  RSpec.describe AuthenticationsController, type: :controller do
    routes { Socializer::Engine.routes }

    # Create a user, authentication, and valid_attributes
    let(:user) { create(:socializer_person) }
    let(:valid_attributes) { { authentication: { provider: 'facebook', uid: user.id, person: user } } }
    let(:authentication) { create(:socializer_authentication, valid_attributes[:authentication]) }

    describe 'when not logged in' do
      describe 'GET #index' do
        it 'requires login' do
          get :index
          expect(response).to redirect_to root_path
        end
      end

      describe 'DELETE #destroy' do
        it 'requires login' do
          delete :destroy, id: authentication
          expect(response).to redirect_to root_path
        end
      end
    end

    describe 'when logged in' do
      # Setting the current user
      before { cookies[:user_id] = user.guid }

      it { should use_before_action(:authenticate_user) }

      describe 'GET #index' do
        before :each do
          get :index
        end

        it 'assigns @authentications' do
          expect(assigns(:authentications)).to match_array([authentication])
        end

        it 'renders the :index template' do
          expect(response).to render_template :index
        end

        it 'returns http success' do
          expect(response).to have_http_status(:success)
        end
      end

      describe 'DELETE #destroy' do
        context 'cannot delete the last authentication' do
          it 'deletes the authentication' do
            authentication
            expect { delete :destroy, id: authentication }.to change(Authentication, :count).by(0)
          end
        end

        context 'can delete when it is not the last authentication' do
          let(:identity) { user.authentications.create!(provider: 'identity', uid: user.id, person: user) }

          it 'deletes the authentication' do
            identity
            authentication
            expect { delete :destroy, id: authentication }.to change(Authentication, :count).by(-1)
          end
        end

        it 'redirects to authentications#index' do
          delete :destroy, id: authentication
          expect(response).to redirect_to authentications_path
        end
      end
    end
  end
end
