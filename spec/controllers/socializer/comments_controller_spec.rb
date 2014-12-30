require 'rails_helper'

module Socializer
  RSpec.describe CommentsController, type: :controller do
    routes { Socializer::Engine.routes }

    # Create a user and a comment
    let(:user) { create(:socializer_person) }
    let(:comment) { create(:socializer_comment, activity_author: user.activity_object) }
    let(:note) { create(:socializer_note) }

    # Setting the current user
    before { cookies[:user_id] = user.guid }

    describe 'GET #new' do
      before :each do
        get :new
      end

      it 'assigns a new Comment to @model' do
        expect(assigns(:comment)).to be_a_new(Comment)
      end

      it 'renders the :new template' do
        expect(response).to render_template :new
      end
    end

    describe 'POST #create' do
      context 'with valid attributes' do
        it 'saves the new comment in the database' do
          expect { post :create, comment: { content: 'This is a comment' } }.to change(Comment, :count).by(1)
        end

        it 'redirects to activities#index' do
          post :create, comment: { content: 'This is a comment', activity_target_id: note.activity_object.id }
          expect(response).to redirect_to stream_path
        end
      end

      context 'with invalid attributes' do
        it 'is a pending example'
      end
    end

    describe 'GET #edit' do
      before :each do
        get :edit, id: comment
      end

      it 'assigns the requested comment to @comment' do
        expect(assigns(:comment)).to eq comment
      end

      it 'renders the :edit template' do
        expect(response).to render_template :edit
      end
    end

    describe 'PATCH #update' do
      context 'with valid attributes' do
        it 'redirects to activities#index' do
          patch :update, id: comment, comment: { content: 'This is a comment' }
          expect(response).to redirect_to stream_path
        end
      end

      context 'with invalid attributes' do
        it 'is a pending example'
      end
    end

    describe 'DELETE #destroy' do
      it 'deletes the comment' do
        comment
        expect { delete :destroy, id: comment }.to change(Comment, :count).by(-1)
      end

      it 'redirects to activities#index' do
        delete :destroy, id: comment
        expect(response).to redirect_to stream_path
      end
    end
  end
end
