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
        it "successfully creates a user" do
          expect { post :create, params: { provider: :identity } }
            .to change { Person.count }.by(1)
        end

        context "successfully creates a session" do
          context "before the create action" do
            it { expect(cookies.signed[:user_id]).to be_nil }
          end

          context "after the create action" do
            before do
              post :create, params: { provider: :identity }
            end

            it { expect(cookies.signed[:user_id]).not_to be_nil }
          end
        end

        it "redirects the user to the root url" do
          post :create, params: { provider: :identity }
          expect(response).to redirect_to root_path
        end
      end

      context "when a Person does exist" do
        context "when authentication is present" do
          it "is a pending example"
        end

        context "when they are signed in" do
          # Setting the current user
          before { cookies.signed[:user_id] = user.guid }

          it "does not create a user" do
            expect { post :create, params: { provider: :identity } }
              .to change { Person.count }.by(0)
          end

          it "creates an authentication" do
            expect { post :create, params: { provider: :identity } }
              .to change { Authentication.count }.by(1)
          end

          it "redirects the user to the authentications url" do
            post :create, params: { provider: :identity }
            expect(response).to redirect_to authentications_path
          end
        end

        context "when they are not signed in" do
          it "is a pending example"
        end
      end
    end

    describe "#destroy" do
      before do
        post :create, params: { provider: :identity }
      end

      context "resets the session" do
        context "before the destroy action" do
          it { expect(cookies.signed[:user_id]).not_to be_nil }
        end

        context "after the destroy action" do
          before do
            delete :destroy
          end

          it "the cookie should be nil" do
            cookies = controller.send :cookies
            expect(cookies.signed[:user_id]).to be_nil
          end
        end
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
