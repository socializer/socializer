require 'spec_helper'

module Socializer
  describe SharesController do
    pending "add test for action #create to #{__FILE__}"

    # Create a user
    let(:user) { create(:socializer_person) }
    # Setting the current user
    before { cookies[:user_id] = user.guid }

    # Create an activity_object to share
    let(:note) { create(:socializer_note) }

    describe 'GET #new' do
      # Visit the new page
      before { get :new, id: note.activity_object.id, use_route: :socializer }

      it 'should return an activity object' do
        expect(assigns(:activity_object)).to eq(note.activity_object)
      end

      it 'should return an share object' do
        expect(assigns(:share)).to eq(note)
      end
    end

    describe 'GET #create' do
    end
  end
end
