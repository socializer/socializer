# frozen_string_literal: true

require "rails_helper"

module Socializer
  RSpec.describe CommentsController, type: :controller do
    routes { Socializer::Engine.routes }

    # Create a user and a comment
    let(:user) { create(:person) }

    let(:comment) do
      create(:comment, activity_author: user.activity_object)
    end

    let(:valid_params) do
      { comment: { content: "This is a comment",
                   activity_target_id: create(:note).guid } }
    end

    let(:invalid_params) do
      { comment: { content: "",
                   activity_target_id: create(:note).guid } }
    end

    let(:update_params) do
      { id: comment,
        comment: { content: "This is a comment update" } }
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
          get :edit, params: { id: comment }
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
          delete :destroy, params: { id: comment }
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
          expect(response).to render_template :new
        end
      end

      describe "POST #create" do
        context "with valid attributes" do
          it "saves the new comment in the database" do
            expect { post :create, params: valid_params }
              .to change(Comment, :count).by(1)
          end

          it "redirects to activities#index" do
            post :create, params: valid_params
            expect(response).to redirect_to activities_path
          end
        end

        context "with invalid attributes" do
          it "does not save the new comment in the database" do
            expect { post :create, params: invalid_params }
              .not_to change(Comment, :count)
          end

          it "re-renders the :new template" do
            post :create, params: invalid_params
            expect(response).to render_template :new
          end
        end
      end

      describe "GET #edit" do
        before do
          get :edit, params: { id: comment }
        end

        it "renders the :edit template" do
          expect(response).to render_template :edit
        end
      end

      describe "PATCH #update" do
        context "with valid attributes" do
          it "redirects to activities#index" do
            patch :update, params: update_params
            expect(response).to redirect_to activities_path
          end
        end

        context "with invalid attributes" do
          it "is pending", pending: true
        end
      end

      describe "DELETE #destroy" do
        it "deletes the comment" do
          comment
          expect { delete :destroy, params: { id: comment } }
            .to change(Comment, :count).by(-1)
        end

        it "redirects to activities#index" do
          delete :destroy, params: { id: comment }
          expect(response).to redirect_to activities_path
        end
      end
    end
  end
end
