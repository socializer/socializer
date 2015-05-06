require 'rails_helper'

module Socializer
  RSpec.describe Circles::FindContactsController, type: :controller do
    routes { Socializer::Engine.routes }

    # Create a user and contact_of
    let(:user) { create(:socializer_person) }
    let(:people) { Person.all }

    # Setting the current user
    before { cookies[:user_id] = user.guid }

    it { should use_before_action(:authenticate_user) }

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

      it 'assigns @people' do
        expect(assigns(:people)).to match_array(people)
      end
    end
  end
end
