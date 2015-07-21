require "rails_helper"

module Socializer
  RSpec.describe NotesController, type: :controller do
    routes { Socializer::Engine.routes }

    # Create a user, note, privacy, valid_attributes
    let(:user) { create(:person) }

    let(:note) do
      create(:note, activity_author: user.activity_object)
    end

    let(:valid_attributes) do
      { note: { content: "Test",
                object_ids: "public",
                activity_verb: "post"
              }
      }
    end

    describe "when not logged in" do
      describe "GET #new" do
        it "requires login" do
          get :new
          expect(response).to redirect_to root_path
        end
      end

      describe "POST #create" do
        it "requires login" do
          post :create, valid_attributes
          expect(response).to redirect_to root_path
        end
      end

      describe "GET #edit" do
        it "requires login" do
          get :edit, id: note
          expect(response).to redirect_to root_path
        end
      end

      describe "PATCH #update" do
        it "requires login" do
          patch :update, id: note, note: { content: "updated content" }
          expect(response).to redirect_to root_path
        end
      end

      describe "DELETE #destroy" do
        it "requires login" do
          delete :destroy, id: note
          expect(response).to redirect_to root_path
        end
      end
    end

    describe "when logged in" do
      # Setting the current user
      before { cookies.signed[:user_id] = user.guid }

      it { should use_before_action(:authenticate_user) }

      describe "GET #new" do
        before do
          get :new
        end

        it "assigns @note" do
          expect(assigns(:note)).to be_a_new(Note)
        end

        it "renders the :new template" do
          expect(response).to render_template :new
        end

        it "returns http success" do
          expect(response).to have_http_status(:success)
        end
      end

      describe "POST #create" do
        context "with valid attributes" do
          context "format.html" do
            it "saves the new note in the database" do
              expect { post :create, valid_attributes }
                .to change(Note, :count).by(1)
            end

            it "redirects to activities#index" do
              post :create, valid_attributes
              expect(response).to redirect_to activities_path
            end
          end

          context "format.js" do
            it "saves the new note in the database" do
              expect { post :create, valid_attributes, format: :js }
                .to change(Note, :count).by(1)
            end

            it "returns http success" do
              post :create, valid_attributes, format: :js
              expect(response).to have_http_status(:found)
            end
          end
        end

        context "with invalid attributes" do
          it "is a pending example"
        end
      end

      describe "GET #edit" do
        before do
          get :edit, id: note
        end

        it "assigns @note" do
          expect(assigns(:note)).to eq note
        end

        it "renders the :edit template" do
          expect(response).to render_template :edit
        end
      end

      describe "PATCH #update" do
        context "with valid attributes" do
          it "redirects to activities#index" do
            patch :update, id: note, note: { content: "updated content" }
            expect(response).to redirect_to activities_path
          end
        end

        context "with invalid attributes" do
          it "is a pending example"
        end
      end

      describe "DELETE #destroy" do
        let(:note) do
          user.activity_object.notes.create!(valid_attributes[:note])
        end

        it "deletes the note" do
          note
          expect { delete :destroy, id: note }.to change(Note, :count).by(-1)
        end

        it "redirects to activities#index" do
          delete :destroy, id: note
          expect(response).to redirect_to activities_path
        end
      end
    end
  end
end
