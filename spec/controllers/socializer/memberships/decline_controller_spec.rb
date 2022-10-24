# frozen_string_literal: true

require "rails_helper"

module Socializer
  RSpec.describe Memberships::DeclineController do
    routes { Socializer::Engine.routes }

    # Create a user, a group, and a membership
    let(:user) { create(:person) }

    let(:group) do
      create(:group, activity_author: user.activity_object)
    end

    let(:membership_attributes) do
      { group:, activity_member: user.activity_object }
    end

    let(:membership) do
      create(:socializer_membership, membership_attributes)
    end

    context "when not logged in" do
      describe "DELETE #destroy" do
        it "requires login" do
          delete :destroy, params: { id: membership.id }
          expect(response).to redirect_to root_path
        end
      end
    end

    context "when logged in" do
      # Setting the current user
      before { cookies.signed[:user_id] = user.guid }

      specify { is_expected.to use_before_action(:authenticate_user) }

      describe "DELETE #destroy" do
        context "with valid attributes" do
          it "decline the membership" do
            membership
            expect { delete :destroy, params: { id: membership.id } }
              .to change(Membership, :count).by(-1)
          end

          describe "it redirects to groups#pending_invites" do
            before do
              delete :destroy, params: { id: membership.id }
            end

            specify do
              expect(response).to redirect_to groups_pending_invites_path
            end

            specify { expect(response).to have_http_status(:found) }
          end
        end

        context "with invalid attributes" do
          it "is pending", pending: true
        end
      end
    end
  end
end
