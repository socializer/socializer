require "rails_helper"

module Socializer
  RSpec.describe Circles::ActivitiesController, type: :controller do
    routes { Socializer::Engine.routes }

    # Create a user, circle, and activities
    let(:user) { create(:person) }

    let(:circle) do
      create(:circle, activity_author: user.activity_object)
    end

    let(:activities) do
      Activity.circle_stream(actor_uid: circle.id, viewer_id: user.id).decorate
    end

    describe "when not logged in" do
      describe "GET #index" do
        it "requires login" do
          get :index, circle_id: circle
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
          get :index, circle_id: circle
        end

        it "returns http success" do
          expect(response).to have_http_status(:success)
        end

        it "renders the :index template" do
          expect(response).to render_template :index
        end

        it "assigns @circle" do
          expect(assigns(:circle)).to match(circle)
        end

        it "assigns @title" do
          expect(assigns(:title)).to match(circle.display_name)
        end

        it "assigns @current_id" do
          expect(assigns(:current_id)).to eq(circle.guid)
        end

        it "assigns @activities" do
          expect(assigns(:activities)).to match_array(activities)
        end
      end
    end
  end
end
