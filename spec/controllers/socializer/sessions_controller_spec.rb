# frozen_string_literal: true

require "rails_helper"

module Socializer
  RSpec.describe SessionsController, type: :controller do
    routes { Socializer::Engine.routes }

    # Create a user
    let(:user) { create(:person) }

    before do
      request.env["omniauth.auth"] = OmniAuth.config.mock_auth[:identity]
    end

    describe "#create" do
      context "when a Person does not exist" do
        it "should successfully create a user" do
          expect { post :create, provider: :identity }
            .to change { Person.count }.by(1)
        end

        it "should successfully create a session" do
          expect(cookies.signed[:user_id]).to be_nil
          post :create, provider: :identity
          expect(cookies.signed[:user_id]).not_to be_nil
        end

        it "should redirect the user to the root url" do
          post :create, provider: :identity
          expect(response).to redirect_to root_path
        end
      end

      context "when a Person does exist" do
        context "when authentication is present" do
        end

        context "when they are signed in" do
          # Setting the current user
          before { cookies.signed[:user_id] = user.guid }

          it "should not create a user" do
            expect { post :create, provider: :identity }
              .to change { Person.count }.by(0)
          end

          it "should create an authentication" do
            expect { post :create, provider: :identity }
              .to change { Authentication.count }.by(1)
          end

          it "should redirect the user to the authentications url" do
            post :create, provider: :identity
            expect(response).to redirect_to authentications_path
          end
        end

        context "when they are not signed in" do
        end
      end
    end

    describe "#destroy" do
      before do
        post :create, provider: :identity
      end

      it "resets the session" do
        expect(cookies.signed[:user_id]).not_to be_nil
        delete :destroy
        expect(cookies.signed[:user_id]).to be_nil
      end

      it "redirects to the root path" do
        delete :destroy
        expect(response).to redirect_to root_path
      end
    end

    describe "#failure" do
      it "redirects to root path" do
        get :failure
        expect(response).to redirect_to root_path
      end
    end
  end
end
