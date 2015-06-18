require 'rails_helper'

module Socializer
  RSpec.describe GroupsController, type: :controller do
    routes { Socializer::Engine.routes }

    describe 'when not logged in' do
      describe 'GET #index' do
        it 'requires login' do
          get :index
          expect(response).to redirect_to root_path
        end
      end

      describe 'GET #new' do
        it 'requires login' do
          get :new
          expect(response).to redirect_to root_path
        end
      end
    end

    describe 'when logged in' do
      # Create a user and a group
      let(:user) { create(:socializer_person) }
      let(:group) { create(:socializer_group, activity_author: user.activity_object) }
      let(:membership) { Membership.find_by(group_id: group.id) }
      let(:privacy) { Socializer::Group.privacy.find_value(:public).value }
      let(:valid_attributes) { { group: { author_id: user.guid, display_name: 'Test', privacy: privacy } } }
      let(:invalid_attributes) { { group: { author_id: user.guid, display_name: '', privacy: nil } } }

      # Setting the current user
      before { cookies[:user_id] = user.guid }

      it { should use_before_action(:authenticate_user) }

      describe 'GET #index' do
        before :each do
          get :index
        end

        # it 'assigns @groups' do
        #   expect(assigns(:groups)).to match_array([group])
        # end

        it 'renders the :index template' do
          expect(response).to render_template :index
        end
      end

      describe 'GET #show' do
        before :each do
          get :show, id: group
        end

        it 'assigns the requested group to @group' do
          expect(assigns(:group)).to eq group
        end

        it 'assigns the requested groups membership to @membership' do
          expect(assigns(:membership)).to eq membership
        end

        it 'renders the show template' do
          expect(response).to render_template :show
        end
      end

      describe 'GET #new' do
        before :each do
          get :new
        end

        it 'assigns a new Group to @group' do
          expect(assigns(:group)).to be_a_new(Group)
        end

        it 'renders the :new template' do
          expect(response).to render_template :new
        end
      end

      describe 'POST #create' do
        context 'with valid attributes' do
          it 'saves the new group in the database' do
            expect { post :create, valid_attributes }.to change(Group, :count).by(1)
          end

          it 'redirects to group#show' do
            post :create, valid_attributes
            expect(response).to redirect_to group_path(assigns[:group])
          end
        end

        context 'with invalid attributes' do
          it 'does not save the new circle in the database' do
            expect { post :create, invalid_attributes }.not_to change(Group, :count)
          end

          it 're-renders the :new template' do
            post :create, invalid_attributes
            expect(response).to render_template :new
          end
        end
      end

      describe 'GET #edit' do
        before :each do
          get :edit, id: group
        end

        it 'assigns the requested group to @group' do
          expect(assigns(:group)).to eq group
        end

        it 'renders the :edit template' do
          expect(response).to render_template :edit
        end
      end

      describe 'PATCH #update' do
        context 'with valid attributes' do
          let(:privacy) { Socializer::Group.privacy.find_value(:private).value }

          it 'redirects to groups#show' do
            patch :update, id: group, group: { privacy: privacy }
            expect(response).to redirect_to group_path(assigns[:group])
          end
        end

        context 'with invalid attributes' do
          it 'is a pending example'
        end
      end

      describe 'DELETE #destroy' do
        context 'cannot delete a group that has members' do
          it 'deletes the group' do
            group
            expect { delete :destroy, id: group }.not_to change(Group, :count)
          end
        end

        context 'can delete a group that has no members' do
          before :each do
            group.leave(user)
          end

          it 'deletes the group' do
            group
            expect { delete :destroy, id: group }.to change(Group, :count).by(-1)
          end

          it 'redirects to groups#index' do
            delete :destroy, id: group
            expect(response).to redirect_to groups_path
          end
        end
      end

      describe 'POST #invite' do
        let(:invited_user) { create(:socializer_person) }

        it 'redirects to groups#show' do
          post :invite, id: group, person_id: invited_user
          expect(response).to redirect_to group_path(group)
        end
      end
    end
  end
end
