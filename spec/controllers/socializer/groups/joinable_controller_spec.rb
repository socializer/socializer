require 'rails_helper'

module Socializer
  RSpec.describe Groups::JoinableController, type: :controller do
    routes { Socializer::Engine.routes }

    # Create a user and a group
    let(:user) { create(:socializer_person) }
    let(:group) { create(:socializer_group, activity_author: user.activity_object) }
    let(:membership) { Membership.find_by(group_id: group.id) }
    let(:privacy) { Socializer::Group.privacy.find_value(:public).value }
    let(:valid_attributes) { { group: { author_id: user.guid, display_name: 'Test', privacy: privacy } } }
    let(:invalid_attributes) { { group: { author_id: user.guid, display_name: '', privacy: nil } } }

    # Setting the current user
    before { cookies[:user_id] = user.guid }

    describe 'GET #index' do
      before :each do
        get :index
      end

      it 'returns http success' do
        expect(response).to have_http_status(:success)
      end

      it 'renders the :index template' do
        expect(response).to render_template :index
      end

      it 'assigns @groups' do
        expect(assigns(:groups)).to match_array([group])
      end
    end
  end
end
