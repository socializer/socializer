require 'rails_helper'

module Socializer
  module Activities
    RSpec.describe SharesController, type: :controller do
      routes { Socializer::Engine.routes }

      # Create a user
      let(:user) { create(:socializer_person) }
      # Setting the current user
      before { cookies[:user_id] = user.guid }

      # Create an activity_object to share
      let(:note) { create(:socializer_note) }

      describe 'GET #new' do
        # Visit the new page
        before { get :new, id: note.activity_object.id }

        it 'return an activity object' do
          expect(assigns(:activity_object)).to eq(note.activity_object)
        end

        it 'return an share object' do
          expect(assigns(:share)).to eq(note)
        end
      end

      describe 'POST #create' do
        it 'is a pending example'
      end
    end
  end
end
