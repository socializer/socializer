require 'rails_helper'

module Socializer
  RSpec.describe People::LikesController, type: :controller do
    routes { Socializer::Engine.routes }

    # Create a user and likes
    let(:user) { create(:socializer_person) }
    let(:likes) { user.likes }

    # Setting the current user
    before { cookies[:user_id] = user.guid }

    describe 'GET #index' do
      before :each do
        get :index, id: user.id
      end

      it 'returns http success' do
        expect(response).to have_http_status(:success)
      end

      it 'renders the :index template' do
        expect(response).to render_template :index
      end

      it 'assigns @person' do
        expect(assigns(:person)).to match(user)
      end

      it 'assigns @likes' do
        expect(assigns(:likes)).to match_array(likes)
      end
    end
  end
end
