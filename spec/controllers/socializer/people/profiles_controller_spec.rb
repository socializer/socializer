require "spec_helper"

module Socializer
  RSpec.describe People::ProfilesController, type: :controller do
    routes { Socializer::Engine.routes }

    # Create a user nad profile
    let(:user) { create(:person) }

    let(:valid_attributes) do
      { person_id: user,
        person_profile: { display_name: "test", url: "http://test.org" }
      }
    end

    let(:profile) do
      user.profiles.create!(valid_attributes[:person_profile])
    end

    let(:update_attributes) do
      { id: profile,
        person_id: user,
        person_profile: { display_name: "updated content" }
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
          post :create, valid_attributes
          expect(response).to redirect_to root_path
        end
      end

      describe "GET #edit" do
        it "requires login" do
          get :edit, id: profile, person_id: user
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
          delete :destroy, id: profile, person_id: user
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

        it "assigns a new Person::Profile to @profile" do
          expect(assigns(:profile)).to be_a_new(Person::Profile)
        end

        it "renders the :new template" do
          expect(response).to render_template :new
        end
      end

      describe "POST #create" do
        context "with valid attributes" do
          it "saves the new profile in the database" do
            expect { post :create, valid_attributes }
              .to change(Person::Profile, :count).by(1)
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

      describe "GET #edit" do
        before do
          get :edit, id: profile, person_id: user
        end

        it "assigns the requested profile to @profile" do
          expect(assigns(:profile)).to eq profile
        end

        it "renders the :edit template" do
          expect(response).to render_template :edit
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
        it "deletes the profile" do
          profile
          expect { delete :destroy, id: profile, person_id: user }
            .to change(Person::Profile, :count).by(-1)
        end

        it "redirects to people#show" do
          delete :destroy, id: profile, person_id: user
          expect(response).to redirect_to user
        end
      end
    end
  end
end
