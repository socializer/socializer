# frozen_string_literal: true

require "spec_helper"

module Socializer
  RSpec.describe People::EducationsController, type: :controller do
    routes { Socializer::Engine.routes }

    # Create a user nad education
    let(:user) { create(:person) }

    let(:valid_attributes) do
      { person_id: user,
        person_education: { school_name: "Test School",
                            major_or_field_of_study: "Student",
                            started_on: Time.zone.now.to_date } }
    end

    let(:invalid_attributes) do
      { person_id: user,
        person_education: { school_name: "",
                            major_or_field_of_study: "Student",
                            started_on: nil } }
    end

    let(:education) do
      user.educations.create!(valid_attributes[:person_education])
    end

    let(:update_attributes) do
      { id: education,
        person_id: user,
        person_education: { major_or_field_of_study: "CS" } }
    end

    describe "when not logged in" do
      describe "GET #new" do
        it "requires login" do
          get :new, params: { person_id: user }
          expect(response).to redirect_to root_path
        end
      end

      describe "POST #create" do
        it "requires login" do
          post :create, params: { person_education: valid_attributes,
                                  person_id: user }

          expect(response).to redirect_to root_path
        end
      end

      describe "GET #edit" do
        it "requires login" do
          get :edit, params: { id: education, person_id: user }
          expect(response).to redirect_to root_path
        end
      end

      describe "PATCH #update" do
        it "requires login" do
          patch :update, params: update_attributes
          expect(response).to redirect_to root_path
        end
      end

      describe "DELETE #destroy" do
        it "requires login" do
          delete :destroy, params: { id: education, person_id: user }
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
          get :new, params: { person_id: user }
        end

        it "renders the :new template" do
          expect(response).to render_template :new
        end
      end

      describe "POST #create" do
        context "with valid attributes" do
          it "saves the new education in the database" do
            expect { post :create, params: valid_attributes }
              .to change(Person::Education, :count).by(1)
          end

          it "redirects to people#show" do
            post :create, params: valid_attributes
            expect(response).to redirect_to user
          end
        end

        context "with invalid attributes" do
          it "does not save the new education in the database" do
            expect { post :create, params: invalid_attributes }
              .not_to change(Person::Education, :count)
          end

          it "re-renders the :new template" do
            post :create, params: invalid_attributes
            expect(response).to render_template :new
          end
        end
      end

      describe "GET #edit" do
        before do
          get :edit, params: { id: education, person_id: user }
        end

        it "renders the :edit template" do
          expect(response).to render_template :edit
        end
      end

      describe "PATCH #update" do
        context "with valid attributes" do
          before do
            patch :update, params: update_attributes
          end

          it { expect(response).to have_http_status(:found) }

          it "redirects to people#show" do
            expect(response).to redirect_to user
          end

          it "changes the attributes" do
            education.reload
            expect(education.major_or_field_of_study).to eq("CS")
          end
        end

        context "with invalid attributes" do
          let(:update_attributes) do
            { id: education,
              person_id: user,
              person_education: { school_name: "" } }
          end

          before do
            patch :update, params: update_attributes
          end

          it { expect(response).to have_http_status(:ok) }

          it "does not change the attributes" do
            education.reload
            expect(education.school_name).not_to eq("")
          end

          it "renders the :edit template" do
            expect(response).to render_template :edit
          end
        end
      end

      describe "DELETE #destroy" do
        let(:delete_attributes) do
          { id: education, person_id: user}
        end

        it "deletes the education" do
          education
          expect { delete :destroy, params: delete_attributes }
            .to change(Person::Education, :count).by(-1)
        end

        context "redirects to people#show" do
          before do
            delete :destroy, params: delete_attributes
          end

          it { expect(response).to redirect_to user }
          it { expect(response).to have_http_status(:found) }
        end
      end
    end
  end
end
