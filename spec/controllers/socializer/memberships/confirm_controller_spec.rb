# frozen_string_literal: true

require "rails_helper"

module Socializer
  RSpec.describe Memberships::ConfirmController do
    routes { Socializer::Engine.routes }

    # Create a user, a group, and a membership
    let(:user) { create(:person) }

    let(:group) do
      create(:group, activity_author: user.activity_object)
    end

    let(:membership_attributes) do
      { active: false, group:, activity_member: user.activity_object }
    end

    let(:membership) do
      create(:socializer_membership, membership_attributes)
    end

    context "when not logged in" do
      describe "POST #create" do
        it "requires login" do
          post :create, params: { id: membership.id }
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
          context "with confirm the membership" do
            context "when before the #create actions" do
              specify { expect(membership.active).to be false }
            end

            context "when after the #create actions" do
              before do
                post :create, params: { id: membership.id }
              end

              specify { expect(membership.reload.active).to be(true) }
              specify { expect(response).to have_http_status(:found) }
            end
          end

          describe "it redirects to groups#show" do
            before do
              post :create, params: { id: membership.id }
            end

            specify { expect(response).to redirect_to membership.group }
            specify { expect(response).to have_http_status(:found) }
          end
        end

        context "with invalid attributes" do
          it "is pending", pending: "TO DO"
        end
      end
    end
  end
end
