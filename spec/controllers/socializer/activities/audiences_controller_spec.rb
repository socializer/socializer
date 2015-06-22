require 'rails_helper'

module Socializer
  RSpec.describe Activities::AudiencesController, type: :controller do
    routes { Socializer::Engine.routes }

    # Create a user, audience, and activities
    let(:user) { create(:socializer_person) }
    let(:note) { user.activity_object.notes.create!(content: 'Test note', object_ids: ['public'], activity_verb: 'post') }
    let(:activity) { Activity.find_by(activity_object_id: note.activity_object.id) }
    let(:audience_list) { ActivityAudienceList.new(activity: activity).perform }

    describe 'when not logged in' do
      describe 'GET #index' do
        it 'requires login' do
          get :index, id: activity
          expect(response).to redirect_to root_path
        end
      end
    end

    describe 'when logged in' do
      # Setting the current user
      before { cookies[:user_id] = user.guid }

      it { should use_before_action(:authenticate_user) }

      describe 'GET #index' do
        before :each do
          get :index, id: activity
        end

        it 'returns http success' do
          expect(response).to have_http_status(:success)
        end

        it 'renders the :index template' do
          expect(response).to render_template :index
        end

        it 'assigns @object_ids' do
          expect(assigns(:object_ids)).to match(audience_list)
        end
      end
    end
  end
end
