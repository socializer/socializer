require "rails_helper"

module Socializer
  RSpec.describe GroupsController, type: :controller do
    routes { Socializer::Engine.routes }

    # Create a user and a group
    let(:user) { create(:socializer_person) }

    let(:group) do
      create(:socializer_group, activity_author: user.activity_object)
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
                 privacy: privacy
               }
      }
    end

    let(:invalid_attributes) do
      { group: { author_id: user.guid, display_name: "", privacy: nil } }
    end

    describe "when not logged in" do
      describe "GET #index" do
        it "requires login" do
          get :index
          expect(response).to redirect_to root_path
        end
      end

      describe "GET #show" do
        it "requires login" do
          get :show, id: group
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
          post :create, valid_attributes
          expect(response).to redirect_to root_path
        end
      end

      describe "GET #edit" do
        it "requires login" do
          get :edit, id: group
          expect(response).to redirect_to root_path
        end
      end

      describe "PATCH #update" do
        it "requires login" do
          patch :update, id: group, group: { privacy: privacy }
          expect(response).to redirect_to root_path
        end
      end

      describe "DELETE #destroy" do
        it "requires login" do
          delete :destroy, id: group
          expect(response).to redirect_to root_path
        end
      end
    end

    describe "when logged in" do
      # Setting the current user
      before { cookies[:user_id] = user.guid }

      it { should use_before_action(:authenticate_user) }

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
          get :show, id: group
        end

        it "assigns the requested group to @group" do
          expect(assigns(:group)).to eq group
        end

        it "assigns the requested groups membership to @membership" do
          expect(assigns(:membership)).to eq membership
        end

        it "renders the show template" do
          expect(response).to render_template :show
        end
      end

      describe "GET #new" do
        before do
          get :new
        end

        it "assigns a new Group to @group" do
          expect(assigns(:group)).to be_a_new(Group)
        end

        it "renders the :new template" do
          expect(response).to render_template :new
        end
      end

      describe "POST #create" do
        context "with valid attributes" do
          it "saves the new group in the database" do
            expect { post :create, valid_attributes }
            .to change(Group, :count).by(1)
          end

          it "redirects to group#show" do
            post :create, valid_attributes
            expect(response).to redirect_to group_path(assigns[:group])
          end
        end

        context "with invalid attributes" do
          it "does not save the new circle in the database" do
            expect { post :create, invalid_attributes }
            .not_to change(Group, :count)
          end

          it "re-renders the :new template" do
            post :create, invalid_attributes
            expect(response).to render_template :new
          end
        end
      end

      describe "GET #edit" do
        before do
          get :edit, id: group
        end

        it "assigns the requested group to @group" do
          expect(assigns(:group)).to eq group
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
            patch :update, id: group, group: { privacy: privacy }
            expect(response).to redirect_to group_path(assigns[:group])
          end
        end

        context "with invalid attributes" do
          it "is a pending example"
        end
      end

      describe "DELETE #destroy" do
        context "cannot delete a group that has members" do
          it "deletes the group" do
            group
            expect { delete :destroy, id: group }
            .not_to change(Group, :count)
          end
        end

        context "can delete a group that has no members" do
          before do
            group.leave(user)
          end

          it "deletes the group" do
            group
            expect { delete :destroy, id: group }
            .to change(Group, :count).by(-1)
          end

          it "redirects to groups#index" do
            delete :destroy, id: group
            expect(response).to redirect_to groups_path
          end
        end
      end
    end
  end
end
