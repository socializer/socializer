# frozen_string_literal: true

require "spec_helper"

module Socializer
  RSpec.describe People::ContributionsController do
    routes { Socializer::Engine.routes }

    # Create a user nad contribution
    let(:user) { create(:person) }

    let(:valid_params) do
      { person_id: user,
        person_contribution: { display_name: "My Test",
                               url: "https://test.org",
                               label: :current_contributor } }
    end

    let(:invalid_params) do
      { person_id: user,
        person_contribution: { display_name: "",
                               url: nil,
                               label: :current_contributor } }
    end

    let(:contribution) do
      user.contributions.create!(valid_params[:person_contribution])
    end

    let(:update_params) do
      { id: contribution,
        person_id: user,
        person_contribution: { label: :past_contributor } }
    end

    context "when not logged in" do
      describe "GET #new" do
        it "requires login" do
          get :new, params: { person_id: user }
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
          get :edit, params: { id: contribution, person_id: user }
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
          delete :destroy, params: { id: contribution, person_id: user }
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
          get :new, params: { person_id: user }
        end

        it "renders the :new template" do
          expect(response).to render_template :new
        end
      end

      describe "POST #create" do
        context "with valid attributes" do
          it "saves the new contribution in the database" do
            expect { post :create, params: valid_params }
              .to change(Person::Contribution, :count).by(1)
          end

          describe "it redirects to people#show" do
            before do
              post :create, params: valid_params
            end

            specify { expect(response).to redirect_to user }
            specify { expect(response).to have_http_status(:found) }
          end
        end

        context "with invalid attributes" do
          it "does not save the new contribution in the database" do
            expect { post :create, params: invalid_params }
              .not_to change(Person::Contribution, :count)
          end

          it "re-renders the :new template" do
            post :create, params: invalid_params
            expect(response).to render_template :new
          end
        end
      end

      describe "GET #edit" do
        before do
          get :edit, params: { id: contribution, person_id: user }
        end

        it "renders the :edit template" do
          expect(response).to render_template :edit
        end
      end

      describe "PATCH #update" do
        context "with valid attributes" do
          it "redirects to people#show" do
            patch :update, params: update_params
            expect(response).to redirect_to user
          end
        end

        context "with invalid attributes" do
          it "is pending", pending: "TO DO"
        end
      end

      describe "DELETE #destroy" do
        it "deletes the contribution" do
          delete_attributes = { id: contribution, person_id: user }
          contribution

          expect { delete :destroy, params: delete_attributes }
            .to change(Person::Contribution, :count).by(-1)
        end

        describe "it redirects to people#show" do
          before do
            delete :destroy, params: { id: contribution, person_id: user }
          end

          specify { expect(response).to redirect_to user }
          specify { expect(response).to have_http_status(:found) }
        end
      end
    end
  end
end
