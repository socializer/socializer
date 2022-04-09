# frozen_string_literal: true

require "rails_helper"

module Socializer
  RSpec.describe Activities::AudiencesController, type: :controller do
    routes { Socializer::Engine.routes }

    # Create a user, audience, and activities
    let(:user) { create(:person) }

    let(:note_attributes) do
      { content: "Test note", object_ids: ["public"], activity_verb: "post" }
    end

    let(:note) do
      user.activity_object.notes.create!(note_attributes)
    end

    let(:activity) do
      Activity.find_by(activity_object_id: note.activity_object.id)
    end

    let(:audience_list) do
      ActivityAudienceList.new(activity:).call
    end

    context "when not logged in" do
      describe "GET #index" do
        it "requires login" do
          get :index, params: { id: activity }
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
          get :index, params: { id: activity }
        end

        it "returns http success" do
          expect(response).to have_http_status(:success)
        end

        it "renders the :index template" do
          expect(response).to render_template :index
        end

        it "assigns @object_ids" do
          expect(assigns(:object_ids)).to match(audience_list)
        end
      end
    end
  end
end
