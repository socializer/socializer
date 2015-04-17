require 'rails_helper'

module Socializer
  RSpec.describe Circles::ContactOfController, type: :controller do
    routes { Socializer::Engine.routes }

    # Create a user and contact_of
    let(:user) { create(:socializer_person) }
    let(:contact_of) { user.contact_of }

    # Setting the current user
    before { cookies[:user_id] = user.guid }

    describe "GET #index" do
      before :each do
        get :index
      end

      it 'returns http success' do
        expect(response).to have_http_status(:success)
      end

      it 'renders the :index template' do
        expect(response).to render_template :index
      end

      it 'assigns @contact_of' do
        expect(assigns(:contact_of)).to match_array(contact_of)
      end
    end
  end
end
