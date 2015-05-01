require 'rails_helper'

module Socializer
  RSpec.describe Memberships::DeclineController, type: :controller do
    routes { Socializer::Engine.routes }

    # Create a user, a group, and a membership
    let(:user) { create(:socializer_person) }
    let(:group) { create(:socializer_group, activity_author: user.activity_object) }
    let(:membership) { create(:socializer_membership, group: group, activity_member: user.activity_object) }

    # Setting the current user
    before { cookies[:user_id] = user.guid }

    it { should use_before_action(:authenticate_user) }

    describe 'DELETE #destroy' do
      context 'with valid attributes' do
        it 'decline the membership' do
          membership
          expect { delete :destroy, id: membership.id }.to change(Membership, :count).by(-1)
        end

        it 'redirects to groups#pending_invites' do
          delete :destroy, id: membership.id
          expect(response).to redirect_to groups_pending_invites_path
        end
      end

      context 'with invalid attributes' do
        it 'is a pending example'
      end
    end
  end
end
