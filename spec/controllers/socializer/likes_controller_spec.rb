require 'spec_helper'

module Socializer
  describe LikesController do

    # before and after are necessary since shares_controller isn't accessible directly in routes.
    before(:all) do
      Rails.application.routes.draw { get ':controller(/:action)'  }
    end

    after(:all) do
      Rails.application.reload_routes!
    end

    # Create a user and a activity
    let(:user) { create(:socializer_person) }
    let(:note_activity) { create(:socializer_activity) }

    # Setting the current user
    before { cookies[:user_id] = user.guid }

    describe 'Set likable and activity' do
      # Verify that the likable variable is set before create and destroy action
      [:create, :destroy].each do |action|
        before { get action, id: note_activity.activity_object.id, format: :js }

        it 'should set likable for action #{action}' do
          expect(assigns(:likable)).to eq(note_activity.activity_object)
        end

        it 'should set activity for action #{action}' do
          expect(assigns(:activity)).to eq(note_activity)
        end
      end
    end

    # Make sure that the note is not liked before liking it.
    it 'should not likes the note before liking it' do
      expect( user.likes?(note_activity.activity_object) ).to be_false
    end

    describe 'GET #create' do
      # Create a like
      before { get :create, id: note_activity.activity_object.id, format: :js }

      it 'should likes the note after liking it' do
        expect( user.likes?(note_activity.activity_object) ).to be_true
      end
    end

    describe 'GET #destroy' do
      # Create a like
      before { get :create,  id: note_activity.activity_object.id, format: :js }
      # Destroy the like
      before { get :destroy, id: note_activity.activity_object.id, format: :js }

      it 'should not likes the note anymore' do
        expect( user.likes?(note_activity.activity_object) ).to be_false
      end
    end

    describe 'GET #index' do
      # Create a like
      before { get :create, id: note_activity.activity_object.id, format: :js }
      # Get the people ou like the activity
      before { get :index,  id: note_activity.id, format: :html }

      it 'should return people' do
        expect(assigns(:object_ids)).to be_present
      end

      it 'should return the user who like the activity' do
        expect(assigns(:object_ids)).to include(user.activity_object)
      end
    end
  end
end
