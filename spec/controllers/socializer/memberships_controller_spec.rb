require 'spec_helper'

module Socializer
  RSpec.describe MembershipsController, type: :controller do
    routes { Socializer::Engine.routes }

    # Create a user, a group, and a membership
    let(:user) { create(:socializer_person) }
    let(:group) { create(:socializer_group, activity_author: user.activity_object) }
    let(:membership) { create(:socializer_membership, group: group, activity_member: user.activity_object) }

    # Setting the current user
    before { cookies[:user_id] = user.guid }

    describe 'POST #create' do
      context 'with valid attributes' do
        it 'saves the new membership in the database' do
          group
          expect { post :create, membership: { group_id: group.id } }.to change(Membership, :count).by(1)
        end

        it 'redirects to groups#show' do
          post :create, membership: { group_id: group.id }
          expect(response).to redirect_to group
        end
      end

      context 'with invalid attributes' do
        it 'is a pending example'
      end
    end

    describe 'DELETE #destroy' do
      it 'deletes the membership' do
        membership
        expect { delete :destroy, id: membership }.to change(Membership, :count).by(-1)
      end
    end

    describe 'POST #confirm' do
      context 'with valid attributes' do
        let(:membership) { create(:socializer_membership, active: false, group: group, activity_member: user.activity_object) }

        it 'confirm the membership' do
          expect(membership.active).to be false

          post :confirm, id: membership.id

          expect(membership.reload.active).to eq(true)
          expect(assigns(:membership)).to eq membership
        end

        it 'redirects to groups#show' do
          post :confirm, id: membership.id
          expect(response).to redirect_to membership.group
        end
      end

      context 'with invalid attributes' do
        it 'is a pending example'
      end
    end
  end
end
