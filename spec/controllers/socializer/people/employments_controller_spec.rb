# frozen_string_literal: true

require "spec_helper"

module Socializer
  RSpec.describe People::EmploymentsController do
    routes { Socializer::Engine.routes }

    # Create a user nad employment
    let(:user) { create(:person) }

    let(:valid_params) do
      { person_id: user,
        person_employment: { employer_name: "Test Company",
                             job_title: "Tester",
                             started_on: Time.zone.now.to_date } }
    end

    let(:invalid_params) do
      { person_id: user,
        person_employment: { employer_name: "",
                             job_title: "Tester",
                             started_on: nil } }
    end

    let(:employment) do
      user.employments.create!(valid_params[:person_employment])
    end

    let(:update_params) do
      { id: employment,
        person_id: user,
        person_employment: { employer_name: "updated content" } }
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
          get :edit, params: { id: employment, person_id: user }
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
          delete :destroy, params: { id: employment, person_id: user }
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

        specify { expect(response).to have_http_status(:ok) }

        it "renders the :new template" do
          expect(response).to render_template :new
        end
      end

      describe "POST #create" do
        context "with valid attributes" do
          it "saves the new employment in the database" do
            expect { post :create, params: valid_params }
              .to change(Person::Employment, :count).by(1)
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
          it "does not save the new employment in the database" do
            expect { post :create, params: invalid_params }
              .not_to change(Person::Employment, :count)
          end

          specify { expect(response).to have_http_status(:ok) }

          it "re-renders the :new template" do
            post :create, params: invalid_params
            expect(response).to render_template :new
          end
        end
      end

      describe "GET #edit" do
        before do
          get :edit, params: { id: employment, person_id: user }
        end

        specify { expect(response).to have_http_status(:ok) }

        it "renders the :edit template" do
          expect(response).to render_template :edit
        end
      end

      describe "PATCH #update" do
        context "with valid attributes" do
          before do
            patch :update, params: update_params
          end

          specify { expect(response).to have_http_status(:found) }

          it "redirects to people#show" do
            expect(response).to redirect_to user
          end

          it "changes the attributes" do
            employment.reload
            expect(employment.employer_name).to eq("updated content")
          end
        end

        context "with invalid attributes" do
          let(:update_params) do
            { id: employment,
              person_id: user,
              person_employment: { employer_name: "" } }
          end

          before do
            patch :update, params: update_params
          end

          specify { expect(response).to have_http_status(:ok) }

          it "does not change the attributes" do
            employment.reload
            expect(employment.employer_name).not_to eq("")
          end

          it "renders the :edit template" do
            expect(response).to render_template :edit
          end
        end
      end

      describe "DELETE #destroy" do
        it "deletes the employment" do
          delete_attributes = { id: employment, person_id: user }
          employment

          expect { delete :destroy, params: delete_attributes }
            .to change(Person::Employment, :count).by(-1)
        end

        describe "it redirects to people#show" do
          before do
            delete :destroy, params: { id: employment, person_id: user }
          end

          specify { expect(response).to redirect_to user }
          specify { expect(response).to have_http_status(:found) }
        end
      end
    end
  end
end
