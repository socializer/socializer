# frozen_string_literal: true

require "spec_helper"

module Socializer
  RSpec.describe MembershipsController do
    routes { Socializer::Engine.routes }

    # Create a user, a group, and a membership
    let(:user) { create(:person) }

    let(:group) do
      create(:group, activity_author: user.activity_object)
    end

    let(:membership) do
      create(:socializer_membership,
             group:,
             activity_member: user.activity_object)
    end

    let(:valid_attributes) { { membership: { group_id: group.id } } }

    context "when not logged in" do
      describe "POST #create" do
        it "requires login" do
          post :create, params: valid_attributes
          expect(response).to redirect_to root_path
        end
      end

      describe "DELETE #destroy" do
        it "requires login" do
          delete :destroy, params: { id: membership }
          expect(response).to redirect_to root_path
        end
      end
    end

    context "when logged in" do
      # Setting the current user
      before { cookies.signed[:user_id] = user.guid }

      specify { is_expected.to use_before_action(:authenticate_user) }

      describe "POST #create" do
        context "with valid attributes" do
          it "saves the new membership in the database" do
            group
            expect { post :create, params: valid_attributes }
              .to change(Membership, :count).by(1)
          end

          describe "it redirects to groups#show" do
            before do
              post :create, params: valid_attributes
            end

            specify { expect(response).to redirect_to group }
            specify { expect(response).to have_http_status(:found) }
          end
        end

        context "with invalid attributes" do
          it "is pending", pending: "TO DO"
        end
      end

      describe "DELETE #destroy" do
        it "deletes the membership" do
          membership
          expect { delete :destroy, params: { id: membership } }
            .to change(Membership, :count).by(-1)
        end
      end
    end
  end
end
