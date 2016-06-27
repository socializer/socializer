# frozen_string_literal: true

require "spec_helper"

module Socializer
  RSpec.describe MembershipsController, type: :controller do
    routes { Socializer::Engine.routes }

    # Create a user, a group, and a membership
    let(:user) { create(:person) }

    let(:group) do
      create(:group, activity_author: user.activity_object)
    end

    let(:membership) do
      create(:socializer_membership,
             group: group,
             activity_member: user.activity_object)
    end

    let(:valid_attributes) { { membership: { group_id: group.id } } }

    describe "when not logged in" do
      describe "POST #create" do
        it "requires login" do
          post :create, valid_attributes
          expect(response).to redirect_to root_path
        end
      end

      describe "DELETE #destroy" do
        it "requires login" do
          delete :destroy, id: membership
          expect(response).to redirect_to root_path
        end
      end
    end

    describe "when logged in" do
      # Setting the current user
      before { cookies.signed[:user_id] = user.guid }

      it { should use_before_action(:authenticate_user) }

      describe "POST #create" do
        context "with valid attributes" do
          it "saves the new membership in the database" do
            group
            expect { post :create, valid_attributes }
              .to change(Membership, :count).by(1)
          end

          it "redirects to groups#show" do
            post :create, valid_attributes
            expect(response).to redirect_to group
          end
        end

        context "with invalid attributes" do
          it "is a pending example"
        end
      end

      describe "DELETE #destroy" do
        it "deletes the membership" do
          membership
          expect { delete :destroy, id: membership }
            .to change(Membership, :count).by(-1)
        end
      end
    end
  end
end
