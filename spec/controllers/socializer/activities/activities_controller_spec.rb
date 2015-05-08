require 'rails_helper'

module Socializer
  RSpec.describe Activities::ActivitiesController, type: :controller do
    routes { Socializer::Engine.routes }

    # Create a user, activity, and activities
    let(:user) { create(:socializer_person) }
    let(:note) { create(:socializer_note, activity_author: user.activity_object) }
    let(:result) { ActivityCreator.new(actor_id: user.guid, activity_object_id: note.guid, verb: 'post', object_ids: 'public').perform }
    let(:activity) { result.activity.decorate }
    let(:activities) { Activity.activity_stream(actor_uid: activity.id, viewer_id: user.id).decorate }

    # Setting the current user
    before { cookies[:user_id] = user.guid }

    it { should use_before_action(:authenticate_user) }

    describe 'GET #index' do
      before :each do
        get :index, activity_id: activity
      end

      it 'returns http success' do
        expect(response).to have_http_status(:success)
      end

      it 'renders the :index template' do
        expect(response).to render_template :index
      end

      it 'assigns @activity' do
        expect(assigns(:activity)).to match(activity)
      end

      it 'assigns @title' do
        expect(assigns(:title)).to match('Activity stream')
      end

      it 'assigns @current_id' do
        expect(assigns(:current_id)).to eq(nil)
      end

      it 'assigns @activities' do
        expect(assigns(:activities)).to match_array(activities)
      end
    end
  end
end
