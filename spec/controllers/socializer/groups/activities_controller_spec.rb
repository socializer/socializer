require 'rails_helper'

module Socializer
  RSpec.describe Groups::ActivitiesController, type: :controller do
    routes { Socializer::Engine.routes }

    # Create a user, group, and activities
    let(:user) { create(:socializer_person) }
    let(:group) { create(:socializer_group, activity_author: user.activity_object) }
    let(:activities) { Activity.group_stream(actor_uid: group.id, viewer_id: user.id).decorate }

    # Setting the current user
    before { cookies[:user_id] = user.guid }

    it { should use_before_action(:authenticate_user) }

    describe 'GET #index' do
      before :each do
        get :index, group_id: group
      end

      it 'returns http success' do
        expect(response).to have_http_status(:success)
      end

      it 'renders the :index template' do
        expect(response).to render_template :index
      end

      it 'assigns @group' do
        expect(assigns(:group)).to match(group)
      end

      it 'assigns @title' do
        expect(assigns(:title)).to match(group.display_name)
      end

      it 'assigns @current_id' do
        expect(assigns(:current_id)).to eq(group.guid)
      end

      it 'assigns @activities' do
        expect(assigns(:activities)).to match_array(activities)
      end
    end
  end
end
