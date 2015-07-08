require "rails_helper"

module Socializer
  RSpec.describe Circles::ContactsController, type: :controller do
    routes { Socializer::Engine.routes }

    # Create a user and a contact
    let(:user) { create(:socializer_person) }
    let(:contacts) { user.contacts }

    describe "when not logged in" do
      describe "GET #index" do
        it "requires login" do
          get :index
          expect(response).to redirect_to root_path
        end
      end
    end

    describe "when logged in" do
      # Setting the current user
      before { cookies[:user_id] = user.guid }

      it { should use_before_action(:authenticate_user) }

      describe "GET #index" do
        before :each do
          get :index
        end

        it "returns http success" do
          expect(response).to have_http_status(:success)
        end

        it "renders the :index template" do
          expect(response).to render_template :index
        end

        it "assigns @contacts" do
          expect(assigns(:contacts)).to match_array(contacts)
        end
      end
    end
  end
end
