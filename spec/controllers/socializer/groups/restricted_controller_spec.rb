# frozen_string_literal: true

require "rails_helper"

module Socializer
  RSpec.describe Groups::RestrictedController, type: :controller do
    routes { Socializer::Engine.routes }

    # Create a user and a group
    let(:user) { create(:person) }

    let(:privacy) do
      Socializer::Group.privacy.find_value(:restricted).value
    end

    let(:group_attributes) do
      { activity_author: user.activity_object, privacy: }
    end

    let(:group) do
      create(:group, group_attributes)
    end

    context "when not logged in" do
      describe "GET #index" do
        it "requires login" do
          get :index
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

        it "returns http success" do
          expect(response).to have_http_status(:success)
        end

        it "renders the :index template" do
          expect(response).to render_template :index
        end

        it "assigns @groups" do
          expect(assigns(:groups)).to match_array([group])
        end
      end
    end
  end
end
