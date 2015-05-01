require 'rails_helper'

module Socializer
  RSpec.describe People::MessagesController, type: :controller do
    routes { Socializer::Engine.routes }

    # Create a user
    let(:user) { create(:socializer_person) }

    # Setting the current user
    before { cookies[:user_id] = user.guid }

    it { should use_before_action(:authenticate_user) }

    describe 'GET #new' do
      before :each do
        get :new, id: user.id
      end

      it 'returns http success' do
        expect(response).to have_http_status(:success)
      end

      it 'assigns @person' do
        expect(assigns(:person)).to match(user)
      end

      it 'assigns @current_id' do
        expect(assigns(:current_id)).to match(user.guid)
      end

      it 'assigns @note' do
        expect(assigns(:note)).to be_a_new(Note)
      end

      it 'renders the :new template' do
        expect(response).to render_template :new
      end
    end
  end
end
