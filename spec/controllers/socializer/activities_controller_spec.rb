require 'rails_helper'

module Socializer
  RSpec.describe ActivitiesController, type: :controller do
    routes { Socializer::Engine.routes }

    # Create a user, note, and an activity
    let(:user) { create(:socializer_person) }
    let(:note) { create(:socializer_note, activity_author: user.activity_object) }
    let(:result) { ActivityCreator.new(actor_id: user.guid, activity_object_id: note.guid, verb: 'post', object_ids: 'public').perform }
    let(:activity) { result.activity.decorate }

    # Setting the current user
    before { cookies[:user_id] = user.guid }

    describe 'GET #index' do
      before :each do
        get :index
      end

      it 'assigns @activities' do
        expect(assigns(:activities)).to match_array([activity])
      end

      it 'assigns @current_id' do
        expect(assigns(:current_id)).to eq(nil)
      end

      it 'assigns @title' do
        expect(assigns(:title)).to match('Activity stream')
      end

      it 'assigns @note' do
        expect(assigns(:note)).to be_a_new(Note)
      end

      it 'renders the :index template' do
        expect(response).to render_template :index
      end

      it 'returns http success' do
        expect(response).to have_http_status(:success)
      end
    end

    describe 'DELETE #destroy' do
      context 'assigns variables and returns success' do
        before :each do
          delete :destroy,  id: activity, format: :js
        end

        it 'assigns @activity' do
          expect(assigns(:activity)).to eq(activity)
        end

        it 'assigns @activity_guid' do
          expect(assigns(:activity_guid)).to eq(activity.guid)
        end

        it 'returns http success' do
          expect(response).to have_http_status(:success)
        end
      end

      it 'deletes the activity' do
        activity
        expect { delete :destroy, id: activity, format: :js }.to change(Activity, :count).by(-1)
      end
    end
  end
end
