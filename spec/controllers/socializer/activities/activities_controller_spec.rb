# frozen_string_literal: true

require "rails_helper"

module Socializer
  RSpec.describe Activities::ActivitiesController, type: :controller do
    routes { Socializer::Engine.routes }

    # Create a user, activity, and activities
    let(:user) { create(:person) }

    let(:creator_attributes) do
      note = create(:note, activity_author: user.activity_object)

      { actor_id: user.guid,
        activity_object_id: note.guid,
        verb: "post",
        object_ids: "public" }
    end

    let(:activity) do
      CreateActivity.new(creator_attributes).call.decorate
    end

    let(:activities) do
      Activity.activity_stream(actor_uid: activity.id,
                               viewer_id: user.id).decorate
    end

    context "when not logged in" do
      describe "GET #index" do
        it "requires login" do
          get :index, params: { activity_id: activity }
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
          get :index, params: { activity_id: activity }
        end

        it "returns http success" do
          expect(response).to have_http_status(:success)
        end

        it "renders the :index template" do
          expect(response).to render_template(:index)
        end
      end
    end
  end
end
