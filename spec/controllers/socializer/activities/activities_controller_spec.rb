require "rails_helper"

module Socializer
  RSpec.describe Activities::ActivitiesController, type: :controller do
    routes { Socializer::Engine.routes }

    # Create a user, activity, and activities
    let(:user) { create(:person) }

    let(:note) do
      create(:note, activity_author: user.activity_object)
    end

    let(:creator_attributes) do
      { actor_id: user.guid,
        activity_object_id: note.guid,
        verb: "post",
        object_ids: "public"
      }
    end

    let(:result) do
      ActivityCreator.new(creator_attributes).call
    end

    let(:activity) do
      result.decorate
    end

    let(:stream_attributes) do
      { actor_uid: activity.id, viewer_id: user.id }
    end

    let(:activities) do
      Activity.activity_stream(stream_attributes).decorate
    end

    describe "when not logged in" do
      describe "GET #index" do
        it "requires login" do
          get :index, activity_id: activity
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
          get :index, activity_id: activity
        end

        it "returns http success" do
          expect(response).to have_http_status(:success)
        end

        it "renders the :index template" do
          expect(response).to render_template :index
        end

        it "assigns @activity" do
          expect(assigns(:activity)).to match(activity)
        end

        it "assigns @title" do
          expect(assigns(:title)).to match("Activity stream")
        end

        it "assigns @current_id" do
          expect(assigns(:current_id)).to eq(nil)
        end

        it "assigns @activities" do
          expect(assigns(:activities)).to match_array(activities)
        end
      end
    end
  end
end
