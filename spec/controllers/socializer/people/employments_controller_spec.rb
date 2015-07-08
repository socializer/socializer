require "spec_helper"

module Socializer
  RSpec.describe People::EmploymentsController, type: :controller do
    routes { Socializer::Engine.routes }

    # Create a user nad employment
    let(:user) { create(:socializer_person) }
    let(:valid_attributes) { { employer_name: "Test Company", job_title: "Tester" } }
    let(:employment) { user.employments.create!(valid_attributes) }

    describe "when not logged in" do
      describe "POST #create" do
        it "requires login" do
          post :create, person_employment: valid_attributes, person_id: user
          expect(response).to redirect_to root_path
        end
      end

      describe "PATCH #update" do
        it "requires login" do
          patch :update, id: employment, person_id: user, person_employment: { label: "updated content" }
          expect(response).to redirect_to root_path
        end
      end

      describe "DELETE #destroy" do
        it "requires login" do
          delete :destroy, id: employment, person_id: user
          expect(response).to redirect_to root_path
        end
      end
    end

    describe "when logged in" do
      # Setting the current user
      before { cookies[:user_id] = user.guid }

      it { should use_before_action(:authenticate_user) }

      describe "POST #create" do
        context "with valid attributes" do
          it "saves the new employment in the database" do
            expect { post :create, person_employment: valid_attributes, person_id: user }.to change(PersonEmployment, :count).by(1)
          end

          it "redirects to people#show" do
            post :create, person_employment: valid_attributes, person_id: user
            expect(response).to redirect_to user
          end
        end

        context "with invalid attributes" do
          it "is a pending example"
        end
      end

      describe "PATCH #update" do
        context "with valid attributes" do
          it "redirects to people#show" do
            patch :update, id: employment, person_id: user, person_employment: { label: "updated content" }
            expect(response).to redirect_to user
          end
        end

        context "with invalid attributes" do
          it "is a pending example"
        end
      end

      describe "DELETE #destroy" do
        it "deletes the employment" do
          employment
          expect { delete :destroy, id: employment, person_id: user }.to change(PersonEmployment, :count).by(-1)
        end

        it "redirects to people#show" do
          delete :destroy, id: employment, person_id: user
          expect(response).to redirect_to user
        end
      end
    end
  end
end
