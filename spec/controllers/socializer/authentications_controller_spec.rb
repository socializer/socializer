# frozen_string_literal: true

require "rails_helper"

module Socializer
  RSpec.describe AuthenticationsController do
    routes { Socializer::Engine.routes }

    # Create a user, authentication, and valid_params
    let(:user) { create(:person) }

    let(:valid_params) do
      { authentication: { provider: "facebook",
                          uid: user.id,
                          person: user } }
    end

    let(:authentication) do
      create(:authentication, valid_params[:authentication])
    end

    context "when not logged in" do
      describe "GET #index" do
        it "requires login" do
          get :index
          expect(response).to redirect_to root_path
        end
      end

      describe "DELETE #destroy" do
        it "requires login" do
          delete :destroy, params: { id: authentication }
          expect(response).to redirect_to root_path
        end
      end
    end

    context "when logged in" do
      # Setting the current user
      before { cookies.signed[:user_id] = user.guid }

      specify { is_expected.to use_before_action(:authenticate_user) }

      describe "GET #index" do
        before do
          get :index
        end

        it "renders the :index template" do
          expect(response).to render_template :index
        end

        it "returns http success" do
          expect(response).to have_http_status(:success)
        end
      end

      describe "DELETE #destroy" do
        context "when it cannot delete the last authentication" do
          it "deletes the authentication" do
            authentication
            expect { delete :destroy, params: { id: authentication } }
              .not_to change(Authentication, :count)
          end
        end

        context "when it can delete when it is not the last authentication" do
          let(:authentication_attributes) do
            { provider: "identity", uid: user.id, person: user }
          end

          let(:identity) do
            user.authentications.create!(authentication_attributes)
          end

          it "deletes the authentication" do
            identity
            authentication
            expect { delete :destroy, params: { id: authentication } }
              .to change(Authentication, :count).by(-1)
          end
        end

        it "redirects to authentications#index" do
          delete :destroy, params: { id: authentication }
          expect(response).to redirect_to authentications_path
        end
      end
    end
  end
end
