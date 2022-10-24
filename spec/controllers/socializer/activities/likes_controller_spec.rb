# frozen_string_literal: true

require "rails_helper"

module Socializer
  module Activities
    RSpec.describe LikesController do
      routes { Socializer::Engine.routes }

      # Create a user and a activity
      let(:user) { create(:person) }
      let(:note_activity) { create(:activity) }

      context "when not logged in" do
        describe "GET #index" do
          it "requires login" do
            get :index, params: { id: note_activity.id }, format: :html
            expect(response).to redirect_to root_path
          end
        end

        describe "POST #create" do
          it "requires login" do
            post :create, params: { id: note_activity.guid }, format: :js
            expect(response).to redirect_to root_path
          end
        end

        describe "DELETE #destroy" do
          it "requires login" do
            delete :destroy, params: { id: note_activity.guid }, format: :js
            expect(response).to redirect_to root_path
          end
        end
      end

      context "when logged in" do
        # Setting the current user
        before { cookies.signed[:user_id] = user.guid }

        specify { is_expected.to use_before_action(:authenticate_user) }

        describe "Set likable and activity" do
          # Verify that the likable variable is set before create and destroy
          # action
          describe "POST #create" do
            before do
              post :create, params: { id: note_activity.guid }, format: :js
            end

            it "returns http success" do
              expect(response).to have_http_status(:success)
            end

            it "renders the :index template" do
              expect(response).to render_template(:create)
            end
          end

          describe "DELETE #destroy" do
            before do
              delete :destroy, params: { id: note_activity.guid }, format: :js
            end

            it "returns http success" do
              expect(response).to have_http_status(:success)
            end

            it "renders the :index template" do
              expect(response).to render_template(:destroy)
            end
          end
        end

        # Make sure that the note is not liked before liking it.
        it "no likes for the note before liking it" do
          expect(user).not_to be_likes(note_activity.activity_object)
        end

        describe "GET #index" do
          before do
            # Create a like
            post :create, params: { id: note_activity.guid }, format: :js

            # Get the people ou like the activity
            get :index, params: { id: note_activity.id }, format: :html
          end

          it "return people" do
            expect(assigns(:people)).to be_present
          end

          it "return the user who like the activity" do
            expect(assigns(:people)).to include(user)
          end
        end

        describe "GET #create" do
          # Create a like
          before do
            post :create, params: { id: note_activity.guid }, format: :js
          end

          it "likes the note after liking it" do
            expect(user).to be_likes(note_activity.activity_object)
          end
        end

        describe "GET #destroy" do
          before do
            # Create a like
            post :create, params: { id: note_activity.guid }, format: :js

            # Destroy the like
            delete :destroy, params: { id: note_activity.guid }, format: :js
          end

          it "does not like the note anymore" do
            expect(user).not_to be_likes(note_activity.activity_object)
          end
        end
      end
    end
  end
end
