# frozen_string_literal: true

require "rails_helper"

module Socializer
  RSpec.describe NotesController, type: :controller do
    routes { Socializer::Engine.routes }

    # Create a user, note, privacy, valid_params
    let(:user) { create(:person) }

    let(:note) do
      create(:note, activity_author: user.activity_object)
    end

    let(:valid_params) do
      { note: { content: "Test",
                object_ids: "public",
                activity_verb: "post" } }
    end

    let(:update_params) do
      { id: note,
        note: { content: "updated content" } }
    end

    context "when not logged in" do
      describe "GET #new" do
        it "requires login" do
          get :new
          expect(response).to redirect_to root_path
        end
      end

      describe "POST #create" do
        it "requires login" do
          post :create, params: valid_params
          expect(response).to redirect_to root_path
        end
      end

      describe "GET #edit" do
        it "requires login" do
          get :edit, params: { id: note }
          expect(response).to redirect_to root_path
        end
      end

      describe "PATCH #update" do
        it "requires login" do
          patch :update, params: update_params
          expect(response).to redirect_to root_path
        end
      end

      describe "DELETE #destroy" do
        it "requires login" do
          delete :destroy, params: { id: note }
          expect(response).to redirect_to root_path
        end
      end
    end

    context "when logged in" do
      # Setting the current user
      before { cookies.signed[:user_id] = user.guid }

      specify { is_expected.to use_before_action(:authenticate_user) }

      describe "GET #new" do
        before do
          get :new
        end

        it "renders the :new template" do
          expect(response).to render_template(:new)
        end

        it "returns http success" do
          expect(response).to have_http_status(:success)
        end
      end

      describe "POST #create with valid attributes" do
        describe "format.html" do
          it "saves the new note in the database" do
            expect { post :create, params: valid_params }
              .to change(Note, :count).by(1)
          end

          it "redirects to activities#index" do
            post :create, params: valid_params
            expect(response).to redirect_to activities_path
          end
        end

        describe "format.js" do
          before do
            request.env["HTTP_ACCEPT"] = "application/javascript"
          end

          it "saves the new note in the database" do
            expect { post :create, params: valid_params, format: :js }
              .to change(Note, :count).by(1)
          end

          it "returns http ok" do
            post :create, params: valid_params, format: :js
            expect(response).to have_http_status(:ok)
          end

          it "renders the :create template" do
            post :create, params: valid_params, format: :js
            expect(response).to render_template(:create)
          end
        end
      end

      describe "POST #create with invalid attributes" do
        it "is pending", pending: true
      end

      describe "GET #edit" do
        before do
          get :edit, params: { id: note }
        end

        it "renders the :edit template" do
          expect(response).to render_template :edit
        end
      end

      describe "PATCH #update with valid attributes" do
        it "redirects to activities#index" do
          patch :update, params: update_params
          expect(response).to redirect_to activities_path
        end
      end

      describe "PATCH #update with invalid attributes" do
        it "is currently pending", pending: true
      end

      describe "DELETE #destroy" do
        let(:note) do
          user.activity_object.notes.create!(valid_params[:note])
        end

        context "when format.js returns success" do
          before do
            delete :destroy, params: { id: note }, format: :js
          end

          it "returns http success" do
            expect(response).to have_http_status(:success)
          end

          it "renders the :destroy template" do
            expect(response).to render_template(:destroy)
          end
        end

        it "deletes the note" do
          note
          expect { delete :destroy, params: { id: note } }
            .to change(Note, :count).by(-1)
        end

        it "redirects to activities#index" do
          delete :destroy, params: { id: note }
          expect(response).to redirect_to activities_path
        end
      end
    end
  end
end
