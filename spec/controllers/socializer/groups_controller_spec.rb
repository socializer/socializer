# frozen_string_literal: true

require "rails_helper"

module Socializer
  RSpec.describe GroupsController, type: :controller do
    routes { Socializer::Engine.routes }

    # Create a user and a group
    let(:user) { create(:person) }

    let(:group) do
      create(:group, activity_author: user.activity_object)
    end

    let(:membership) do
      Membership.find_by(group_id: group.id)
    end

    let(:privacy) do
      Socializer::Group.privacy.find_value(:public).value
    end

    let(:valid_attributes) do
      { group: { author_id: user.guid,
                 display_name: "Test",
                 privacy: } }
    end

    let(:invalid_attributes) do
      { group: { author_id: user.guid, display_name: "", privacy: nil } }
    end

    context "when not logged in" do
      describe "GET #index" do
        it "requires login" do
          get :index
          expect(response).to redirect_to root_path
        end
      end

      describe "GET #show" do
        it "requires login" do
          get :show, params: { id: group }
          expect(response).to redirect_to root_path
        end
      end

      describe "GET #new" do
        it "requires login" do
          get :new
          expect(response).to redirect_to root_path
        end
      end

      describe "POST #create" do
        it "requires login" do
          post :create, params: valid_attributes
          expect(response).to redirect_to root_path
        end
      end

      describe "GET #edit" do
        it "requires login" do
          get :edit, params: { id: group }
          expect(response).to redirect_to root_path
        end
      end

      describe "PATCH #update" do
        it "requires login" do
          patch :update, params: { id: group, group: { privacy: } }
          expect(response).to redirect_to root_path
        end
      end

      describe "DELETE #destroy" do
        it "requires login" do
          delete :destroy, params: { id: group }
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

        # it "assigns @groups" do
        #   expect(assigns(:groups)).to match_array([group])
        # end

        it "renders the :index template" do
          expect(response).to render_template :index
        end
      end

      describe "GET #show" do
        before do
          get :show, params: { id: group }
        end

        it "renders the show template" do
          expect(response).to render_template :show
        end
      end

      describe "GET #new" do
        before do
          get :new
        end

        it "renders the :new template" do
          expect(response).to render_template :new
        end
      end

      describe "POST #create" do
        context "with valid attributes" do
          it "saves the new group in the database" do
            expect { post :create, params: valid_attributes }
              .to change(Group, :count).by(1)
          end

          it "redirects to group#show" do
            post :create, params: valid_attributes
            expect(response).to have_http_status(:found)
          end
        end

        context "with invalid attributes" do
          it "does not save the new group in the database" do
            expect { post :create, params: invalid_attributes }
              .not_to change(Group, :count)
          end

          it "re-renders the :new template" do
            post :create, params: invalid_attributes
            expect(response).to render_template :new
          end
        end
      end

      describe "GET #edit" do
        before do
          get :edit, params: { id: group }
        end

        it "renders the :edit template" do
          expect(response).to render_template :edit
        end
      end

      describe "PATCH #update" do
        context "with valid attributes" do
          let(:privacy) do
            Socializer::Group.privacy.find_value(:private).value
          end

          it "redirects to groups#show" do
            patch :update, params: { id: group, group: { privacy: } }
            expect(response).to have_http_status(:found)
          end
        end

        context "with invalid attributes" do
          it "is pending" do
            pending "it has not been implemented yet."
            raise
          end
        end
      end

      describe "DELETE #destroy" do
        context "when it cannot delete a group that has members" do
          it "deletes the group" do
            group
            expect { delete :destroy, params: { id: group } }
              .not_to change(Group, :count)
          end
        end

        context "when it can delete a group that has no members" do
          before do
            Group::Services::Leave.new(group:, person: user).call
          end

          it "deletes the group" do
            group
            expect { delete :destroy, params: { id: group } }
              .to change(Group, :count).by(-1)
          end

          it "redirects to groups#index" do
            delete :destroy, params: { id: group }
            expect(response).to redirect_to groups_path
          end
        end
      end
    end
  end
end
