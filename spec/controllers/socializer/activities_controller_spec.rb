require "rails_helper"

module Socializer
  RSpec.describe ActivitiesController, type: :controller do
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
        object_ids: "public"
      }
    end

    let(:result) { CreateActivity.new(activity_attributes).call }
    let(:activity) { result.decorate }

    describe "when not logged in" do
      describe "GET #index" do
        it "requires login" do
          get :index
          expect(response).to redirect_to root_path
        end
      end

      describe "DELETE #destroy" do
        it "requires login" do
          delete :destroy, id: activity, format: :js
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

        it "assigns @activities" do
          expect(assigns(:activities)).to match_array([activity])
        end

        it "assigns @current_id" do
          expect(assigns(:current_id)).to eq(nil)
        end

        it "assigns @title" do
          expect(assigns(:title)).to match("Activity stream")
        end

        it "assigns @note" do
          expect(assigns(:note)).to be_a_new(Note)
        end

        it "renders the :index template" do
          expect(response).to render_template :index
        end

        it "returns http success" do
          expect(response).to have_http_status(:success)
        end
      end

      describe "DELETE #destroy" do
        context "assigns variables and returns success" do
          before do
            delete :destroy, id: activity, format: :js
          end

          it "assigns @activity" do
            expect(assigns(:activity)).to eq(activity)
          end

          it "assigns @activity_guid" do
            expect(assigns(:activity_guid)).to eq(activity.guid)
          end

          it "returns http success" do
            expect(response).to have_http_status(:success)
          end
        end

        it "deletes the activity" do
          activity
          expect { delete :destroy, id: activity, format: :js }
            .to change(Activity, :count).by(-1)
        end
      end
    end
  end
end
