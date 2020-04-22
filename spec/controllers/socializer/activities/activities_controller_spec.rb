# frozen_string_literal: true

require "rails_helper"

module Socializer
  RSpec.describe Activities::ActivitiesController, type: :controller do
    routes { Socializer::Engine.routes }

    # Create a user, activity, and activities
    let(:actor) { create(:person) }
    let(:activity) { Activity::Services::Create.new(actor: actor) }
    let(:result) { activity.call(params: creator_attributes) }
    let(:decorated) { result.success.decorate }

    let(:note) do
      create(:note, activity_author: actor.activity_object)
    end

    let(:creator_attributes) do
      { activity_object_id: note.guid,
        verb: "post",
        object_ids: "public" }
    end

    let(:stream_attributes) do
      { actor_uid: decorated.id, viewer_id: actor.id }
    end

    let(:activities) do
      Activity.activity_stream(stream_attributes).decorate
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
      before { cookies.signed[:user_id] = actor.guid }

      it { is_expected.to use_before_action(:authenticate_user) }

      describe "GET #index" do
        before do
          get :index, params: { activity_id: decorated }
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
