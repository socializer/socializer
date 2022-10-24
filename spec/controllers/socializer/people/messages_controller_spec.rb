# frozen_string_literal: true

require "rails_helper"

module Socializer
  RSpec.describe People::MessagesController do
    routes { Socializer::Engine.routes }

    # Create a user
    let(:user) { create(:person) }

    context "when not logged in" do
      describe "GET #new" do
        it "requires login" do
          get :new, params: { id: user.id }
          expect(response).to redirect_to root_path
        end
      end
    end

    context "when logged in" do
      # Setting the current user
      before { cookies.signed[:user_id] = user.guid }

      specify { is_expected.to use_before_action(:authenticate_user) }

      describe "GET #new" do
        before do
          get :new, params: { id: user.id }
        end

        it "returns http success" do
          expect(response).to have_http_status(:success)
        end

        it "assigns @person" do
          expect(assigns(:person)).to match(user)
        end

        it "renders the :new template" do
          expect(response).to render_template :new
        end
      end
    end
  end
end
