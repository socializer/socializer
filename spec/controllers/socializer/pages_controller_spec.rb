require "rails_helper"

module Socializer
  RSpec.describe PagesController, type: :controller do
    routes { Socializer::Engine.routes }

    it { should_not use_before_action(:authenticate_user) }

    describe "GET #index" do
      before do
        get :index
      end

      context "when not logged in" do
        it "returns http success" do
          expect(response).to have_http_status(:success)
        end
      end

      context "when logged in" do
        it "is a pending example"
        # # Create a user
        # let(:user) { create(:person) }

        # # Setting the current user
        # before { cookies[:user_id] = user.guid }
        # before do
        #   allow(controller).to receive(:signed_in?).and_return(true)
        # end

        # it "redirects to activities#index" do
        #   expect(response).to redirect_to activities_path
        # end
      end
    end
  end
end
