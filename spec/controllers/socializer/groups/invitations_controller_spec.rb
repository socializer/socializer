require "rails_helper"

module Socializer
  RSpec.describe Groups::InvitationsController, type: :controller do
    routes { Socializer::Engine.routes }

    # Create a user and a group
    let(:user) { create(:socializer_person) }
    let(:group) { create(:socializer_group, activity_author: user.activity_object) }

    describe "when not logged in" do
      describe "POST #create" do
        let(:invited_user) { create(:socializer_person) }

        it "requires login" do
          post :create, id: group, person_id: invited_user
          expect(response).to redirect_to root_path
        end
      end
    end

    describe "when logged in" do
      # Setting the current user
      before { cookies[:user_id] = user.guid }

      describe "POST #create" do
        let(:invited_user) { create(:socializer_person) }

        it "redirects to groups#show" do
          post :create, id: group, person_id: invited_user
          expect(response).to redirect_to group_path(group)
        end
      end
    end
  end
end
