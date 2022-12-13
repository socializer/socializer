# frozen_string_literal: true

require "rails_helper"

module Socializer
  RSpec.describe CirclesController do
    routes { Socializer::Engine.routes }

    # Create a user, a circle, and valid+attributes
    let(:user) { create(:person) }

    let(:circle) do
      create(:circle, activity_author: user.activity_object)
    end

    let(:valid_params) do
      { circle: { author_id: user.guid, display_name: "Test" } }
    end

    let(:invalid_params) do
      { circle: { author_id: user.guid, display_name: "" } }
    end

    let(:update_params) do
      { id: circle,
        circle: { display_name: "Test1" } }
    end

    context "when not logged in" do
      describe "GET #index" do
        it "requires login" do
          get :index
          expect(response).to redirect_to root_path
        end
      end

      describe "GET #show" do
        it "requires login" do
          get :show, params: { id: circle }
          expect(response).to redirect_to root_path
        end
      end

      describe "GET #new" do
        it "requires login" do
          get :new
          expect(response).to redirect_to root_path
        end
      end

      describe "POST #create" do
        it "requires login" do
          post :create, params: valid_params
          expect(response).to redirect_to root_path
        end
      end

      describe "GET #edit" do
        it "requires login" do
          get :edit, params: { id: circle }
          expect(response).to redirect_to root_path
        end
      end

      describe "PATCH #update" do
        it "requires login" do
          patch :update, params: update_params
          expect(response).to redirect_to root_path
        end
      end

      describe "DELETE #destroy" do
        it "requires login" do
          delete :destroy, params: { id: circle }
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

      describe "GET #show" do
        before do
          get :show, params: { id: circle }
        end

        it "renders the show template" do
          expect(response).to render_template :show
        end

        it "returns http success" do
          get :show, params: { id: circle }
          expect(response).to have_http_status(:success)
        end
      end

      describe "GET #new" do
        before do
          get :new
        end

        it "renders the :new template" do
          expect(response).to render_template :new
        end

        it "returns http success" do
          get :new
          expect(response).to have_http_status(:success)
        end
      end

      describe "POST #create" do
        context "with valid attributes" do
          it "saves the new circle in the database" do
            expect { post :create, params: valid_params }
              .to change(Circle, :count).by(1)
          end

          it "redirects to circles#contacts" do
            post :create, params: valid_params
            expect(response).to redirect_to contacts_circles_path
          end
        end

        context "with invalid attributes" do
          it "does not save the new circle in the database" do
            expect { post :create, params: invalid_params }
              .not_to change(Circle, :count)
          end

          it "re-renders the :new template" do
            post :create, params: invalid_params
            expect(response).to render_template :new
          end
        end
      end

      describe "GET #edit" do
        before do
          get :edit, params: { id: circle }
        end

        it "renders the :edit template" do
          expect(response).to render_template :edit
        end
      end

      describe "PATCH #update" do
        context "with valid attributes" do
          it "redirects to the updated circle" do
            patch :update, params: update_params
            expect(response).to redirect_to circle
          end
        end

        context "with invalid attributes" do
          it "is pending", pending: "TO DO"
        end
      end

      describe "DELETE #destroy" do
        it "deletes the circle" do
          circle
          expect { delete :destroy, params: { id: circle } }
            .to change(Circle, :count).by(-1)
        end

        it "redirects to contacts#index" do
          delete :destroy, params: { id: circle }
          expect(response).to redirect_to contacts_circles_path
        end
      end
    end
  end
end
