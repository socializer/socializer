require "rails_helper"

module Socializer
  RSpec.describe CommentsController, type: :controller do
    routes { Socializer::Engine.routes }

    # Create a user and a comment
    let(:user) { create(:person) }

    let(:comment) do
      create(:comment, activity_author: user.activity_object)
    end

    let(:note) do
      create(:note)
    end

    let(:valid_attributes) do
      { comment: { content: "This is a comment",
                   activity_target_id: note.guid } }
    end

    let(:update_attributes) do
      { id: comment,
        comment: { content: "This is a comment update" } }
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
          get :edit, id: comment
          expect(response).to redirect_to root_path
        end
      end

      describe "PATCH #update" do
        it "requires login" do
          patch :update, update_attributes
          expect(response).to redirect_to root_path
        end
      end

      describe "DELETE #destroy" do
        it "requires login" do
          delete :destroy, id: comment
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

        it "assigns a new Comment to @model" do
          expect(assigns(:comment)).to be_a_new(Comment)
        end

        it "renders the :new template" do
          expect(response).to render_template :new
        end
      end

      describe "POST #create" do
        context "with valid attributes" do
          it "saves the new comment in the database" do
            expect { post :create, valid_attributes }
              .to change(Comment, :count).by(1)
          end

          it "redirects to activities#index" do
            post :create, valid_attributes
            expect(response).to redirect_to activities_path
          end
        end

        context "with invalid attributes" do
          it "is a pending example"
        end
      end

      describe "GET #edit" do
        before do
          get :edit, id: comment
        end

        it "assigns the requested comment to @comment" do
          expect(assigns(:comment)).to eq comment
        end

        it "renders the :edit template" do
          expect(response).to render_template :edit
        end
      end

      describe "PATCH #update" do
        context "with valid attributes" do
          it "redirects to activities#index" do
            patch :update, update_attributes
            expect(response).to redirect_to activities_path
          end
        end

        context "with invalid attributes" do
          it "is a pending example"
        end
      end

      describe "DELETE #destroy" do
        it "deletes the comment" do
          comment
          expect { delete :destroy, id: comment }
            .to change(Comment, :count).by(-1)
        end

        it "redirects to activities#index" do
          delete :destroy, id: comment
          expect(response).to redirect_to activities_path
        end
      end
    end
  end
end
