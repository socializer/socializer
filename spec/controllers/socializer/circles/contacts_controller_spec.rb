require 'rails_helper'

module Socializer
  RSpec.describe Circles::ContactsController, type: :controller do
    routes { Socializer::Engine.routes }

    # Create a user and a contact
    let(:user) { create(:socializer_person) }
    let(:contact) { create(:socializer_person) }
    let(:circle) { user.circles.create!(display_name: 'Friends').add_contact(contact.id) }
    let(:contacts) { user.contacts }

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

      it 'assigns @contacts' do
        circle
        expect(assigns(:contacts)).to match_array(contacts)
      end
    end
  end
end
