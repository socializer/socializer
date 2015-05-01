require 'rails_helper'

module Socializer
  module Activities
    RSpec.describe SharesController, type: :controller do
      routes { Socializer::Engine.routes }

      # Create a user and a note to share
      let(:user) { create(:socializer_person) }
      let(:note) { create(:socializer_note) }

      # Setting the current user
      before { cookies[:user_id] = user.guid }

      it { should use_before_action(:authenticate_user) }

      describe 'GET #new' do
        # Visit the new page
        before { get :new, id: note.guid }

        it 'return an activity object' do
          expect(assigns(:activity_object)).to eq(note.activity_object)
        end

        it 'return an share object' do
          expect(assigns(:share)).to eq(note)
        end

        it 'renders the :new template' do
          expect(response).to render_template :new
        end
      end

      describe 'POST #create' do
        context 'with valid attributes' do
          let(:object_ids) { Socializer::Audience.privacy.find_value(:public).value.split(',') }

          it 'redirects to circles#contacts' do
            post :create, share: { content: '', object_ids: object_ids, activity_id: note.guid }, id: note
            expect(response).to redirect_to activities_path
          end
        end

        context 'with invalid attributes' do
          it 'is a pending example'
          # it 're-renders the :new template' do
          #   post :create, invalid_attributes
          #   expect(response).to render_template :new
          # end
        end
      end
    end
  end
end
