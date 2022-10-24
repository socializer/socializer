# frozen_string_literal: true

require "rails_helper"

module Socializer
  RSpec.describe Groups::ActivitiesController do
    routes { Socializer::Engine.routes }

    # Create a user, group, and activities
    let(:user) { create(:person) }

    let(:group) do
      create(:group, activity_author: user.activity_object)
    end

    let(:activities) do
      Activity.group_stream(actor_uid: group.id, viewer_id: user.id).decorate
    end

    context "when not logged in" do
      describe "GET #index" do
        it "requires login" do
          get :index, params: { group_id: group }
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
          get :index, params: { group_id: group }
        end

        it "returns http success" do
          expect(response).to have_http_status(:success)
        end

        it "renders the :index template" do
          expect(response).to render_template :index
        end
      end
    end
  end
end
