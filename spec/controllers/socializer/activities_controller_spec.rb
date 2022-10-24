# frozen_string_literal: true

require "rails_helper"

module Socializer
  RSpec.describe ActivitiesController do
    routes { Socializer::Engine.routes }

    # Create a user, note, and an activity
    let(:user) { create(:person) }

    let(:note) do
      create(:note, activity_author: user.activity_object)
    end

    let(:activity_attributes) do
      { actor_id: user.guid,
        activity_object_id: note.guid,
        verb: "post",
        object_ids: "public" }
    end

    let(:result) { CreateActivity.new(activity_attributes).call }
    let(:activity) { result.decorate }

    context "when not logged in" do
      describe "GET #index" do
        it "requires login" do
          get :index
          expect(response).to redirect_to root_path
        end
      end

      describe "DELETE #destroy" do
        it "requires login" do
          delete :destroy, params: { id: activity }, format: :js
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
        context "when it returns success" do
          before do
            delete :destroy, params: { id: activity }, format: :js
          end

          it "returns http success" do
            expect(response).to have_http_status(:success)
          end

          it "renders the :destroy template" do
            expect(response).to render_template :destroy
          end
        end

        it "deletes the activity" do
          activity
          expect { delete :destroy, params: { id: activity }, format: :js }
            .to change(Activity, :count).by(-1)
        end
      end
    end
  end
end
