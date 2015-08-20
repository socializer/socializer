require "spec_helper"

module Socializer
  RSpec.describe People::EducationsController, type: :controller do
    routes { Socializer::Engine.routes }

    # Create a user nad education
    let(:user) { create(:person) }

    let(:valid_attributes) do
      {
        person_id: user,
        person_education: { school_name: "Test School",
                            major_or_field_of_study: "Student",
                            started_on: Time.zone.now.to_date
                          }
      }
    end

    let(:education) do
      user.educations.create!(valid_attributes[:person_education])
    end

    let(:update_attributes) do
      { id: education,
        person_id: user,
        person_education: { label: "updated content" }
      }
    end

    describe "when not logged in" do
      describe "GET #new" do
        it "requires login" do
          get :new, person_id: user
          expect(response).to redirect_to root_path
        end
      end

      describe "POST #create" do
        it "requires login" do
          post :create, person_education: valid_attributes, person_id: user
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
          delete :destroy, id: education, person_id: user
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
          get :new, person_id: user
        end

        it "assigns a new Person::Education to @person_education" do
          expect(assigns(:person_education)).to be_a_new(Person::Education)
        end

        it "renders the :new template" do
          expect(response).to render_template :new
        end
      end

      describe "POST #create" do
        context "with valid attributes" do
          it "saves the new education in the database" do
            expect { post :create, valid_attributes }
              .to change(Person::Education, :count).by(1)
          end

          it "redirects to people#show" do
            post :create, valid_attributes
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
            patch :update, update_attributes
            expect(response).to redirect_to user
          end
        end

        context "with invalid attributes" do
          it "is a pending example"
        end
      end

      describe "DELETE #destroy" do
        it "deletes the education" do
          education
          expect { delete :destroy, id: education, person_id: user }
            .to change(Person::Education, :count).by(-1)
        end

        it "redirects to people#show" do
          delete :destroy, id: education, person_id: user
          expect(response).to redirect_to user
        end
      end
    end
  end
end
