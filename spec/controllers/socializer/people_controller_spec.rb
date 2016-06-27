# frozen_string_literal: true

require "rails_helper"

module Socializer
  RSpec.describe PeopleController, type: :controller do
    routes { Socializer::Engine.routes }

    # Create a user
    let(:user) { create(:person) }

    describe "when not logged in" do
      describe "GET #index" do
        it "requires login" do
          get :index
          expect(response).to redirect_to root_path
        end
      end

      describe "GET #show" do
        it "requires login" do
          get :show, id: user
          expect(response).to redirect_to root_path
        end
      end

      describe "GET #edit" do
        it "requires login" do
          get :edit, id: user
          expect(response).to redirect_to root_path
        end
      end

      describe "PATCH #update" do
        it "requires login" do
          patch :update, id: user, person: { tagline: "This is a tagline" }
          expect(response).to redirect_to root_path
        end
      end
    end

    describe "when logged in" do
      # Setting the current user
      before { cookies.signed[:user_id] = user.guid }

      it { should use_before_action(:authenticate_user) }

      describe "GET #index" do
        before do
          get :index
        end

        it "assigns @people" do
          expect(assigns(:people)).to match_array([user])
        end

        it "renders the :index template" do
          expect(response).to render_template :index
        end
      end

      describe "GET #show" do
        before do
          get :show, id: user
        end

        it "assigns @person" do
          expect(assigns(:person)).to eq user
        end

        it "renders the show template" do
          expect(response).to render_template :show
        end
      end

      describe "GET #edit" do
        before do
          get :edit, id: user
        end

        it "assigns @person" do
          expect(assigns(:person)).to eq user
        end

        it "renders the :edit template" do
          expect(response).to render_template :edit
        end
      end

      describe "PATCH #update" do
        context "with valid attributes" do
          it "redirects to people#show" do
            patch :update, id: user, person: { tagline: "This is a tagline" }
            expect(response).to redirect_to user
          end
        end

        context "with invalid attributes" do
          it "is a pending example"
        end
      end
    end
  end
end
