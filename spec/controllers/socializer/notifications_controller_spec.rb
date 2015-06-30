require 'rails_helper'

module Socializer
  RSpec.describe NotificationsController, type: :controller do
    routes { Socializer::Engine.routes }

    # Create a user and notification
    let(:user) { create(:socializer_person) }
    let(:notification) { create(:socializer_notification) }

    describe 'when not logged in' do
      describe 'GET #index' do
        it 'requires login' do
          get :index
          expect(response).to redirect_to root_path
        end
      end

      describe 'GET #show' do
        it 'requires login' do
          get :show, id: notification
          expect(response).to redirect_to root_path
        end
      end
    end

    describe 'when logged in' do
      # Setting the current user
      before { cookies[:user_id] = user.guid }

      it { should use_before_action(:authenticate_user) }

      describe 'GET #index' do
        let(:params) { { note: { content: 'Test', object_ids: 'public', activity_verb: 'post' } } }
        let(:note) { user.activity_object.notes.create!(params[:note]) }
        let(:activity) { Activity.find_by(activity_object_id: note.guid).decorate }

        context 'when unread notifications are 0' do
          before :each do
            get :index
          end

          it 'assigns @notifications' do
            expect(assigns(:notifications)).to match_array(activity.notifications)
          end

          it 'renders the :index template' do
            expect(response).to render_template :index
          end

          it 'returns http success' do
            get :index
            expect(response).to have_http_status(:success)
          end
        end

        context 'when unread notifications are > 0' do
          let(:activity_object) { user.activity_object }

          it 'reset to 0' do
            activity_object.update!(unread_notifications_count: 10)
            get :index
            expect(activity_object.reload.unread_notifications_count).to eq(0)
          end
        end
      end

      describe 'GET #show' do
        before :each do
          get :show, id: notification
        end

        it 'marks the notification as read' do
          expect(notification.reload.read).to be true
        end

        it 'renders the show template' do
          expect(response).to redirect_to activity_activities_path(activity_id: notification.activity.id)
        end
      end
    end
  end
end
