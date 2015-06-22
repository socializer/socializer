require 'rails_helper'

module Socializer
  module Activities
    RSpec.describe LikesController, type: :controller do
      routes { Socializer::Engine.routes }

      # Create a user and a activity
      let(:user) { create(:socializer_person) }
      let(:note_activity) { create(:socializer_activity) }

      describe 'when not logged in' do
        describe 'GET #index' do
          it 'requires login' do
            get :index,  id: note_activity.id, format: :html
            expect(response).to redirect_to root_path
          end
        end

        describe 'POST #create' do
          it 'requires login' do
            post :create, id: note_activity.guid, format: :js
            expect(response).to redirect_to root_path
          end
        end

        describe 'DELETE #destroy' do
          it 'requires login' do
            delete :destroy, id: note_activity.guid, format: :js
            expect(response).to redirect_to root_path
          end
        end
      end

      describe 'when logged in' do
        # Setting the current user
        before { cookies[:user_id] = user.guid }

        it { should use_before_action(:authenticate_user) }

        describe 'Set likable and activity' do
          # Verify that the likable variable is set before create and destroy action
          [:create, :destroy].each do |action|
            before { post action, id: note_activity.guid, format: :js }

            it "set likable for action #{action}" do
              expect(assigns(:likable)).to eq(note_activity.activity_object)
            end

            it "set activity for action #{action}" do
              expect(assigns(:activity)).to eq(note_activity)
            end
          end
        end

        # Make sure that the note is not liked before liking it.
        it 'no likes for the note before liking it' do
          expect(user.likes?(note_activity.activity_object)).to be_falsey
        end

        describe 'GET #index' do
          # Create a like
          before { post :create, id: note_activity.guid, format: :js }
          # Get the people ou like the activity
          before { get :index,  id: note_activity.id, format: :html }

          it 'return people' do
            expect(assigns(:people)).to be_present
          end

          it 'return the user who like the activity' do
            expect(assigns(:people)).to include(user)
          end
        end

        describe 'GET #create' do
          # Create a like
          before { post :create, id: note_activity.guid, format: :js }

          it 'likes the note after liking it' do
            expect(user.likes?(note_activity.activity_object)).to be_truthy
          end
        end

        describe 'GET #destroy' do
          # Create a like
          before { post :create,  id: note_activity.guid, format: :js }
          # Destroy the like
          before { delete :destroy, id: note_activity.guid, format: :js }

          it 'does not like the note anymore' do
            expect(user.likes?(note_activity.activity_object)).to be_falsey
          end
        end
      end
    end
  end
end
