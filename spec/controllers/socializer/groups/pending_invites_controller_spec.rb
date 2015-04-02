require 'rails_helper'

module Socializer
  RSpec.describe Groups::PendingInvitesController, type: :controller do
    routes { Socializer::Engine.routes }

    # Create a user and a group
    let(:user) { create(:socializer_person) }
    let(:group) { create(:socializer_group, activity_author: user.activity_object) }

    # Setting the current user
    before { cookies[:user_id] = user.guid }

    describe 'GET #index' do
      before :each do
        get :index
      end

      it 'returns http success' do
        expect(response).to have_http_status(:success)
      end

      it 'renders the :index template' do
        expect(response).to render_template :index
      end

      it 'assigns @pending_invites' do
        expect(assigns(:pending_invites)).to match_array([])
      end

      context 'with a pending invite' do
        it 'is a pending example'
      end
    end
  end
end
