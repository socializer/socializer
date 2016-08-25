# frozen_string_literal: true

require "spec_helper"

module Socializer
  RSpec.describe People::PhonesController, type: :controller do
    routes { Socializer::Engine.routes }

    # Create a user and phone
    let(:user) { create(:person) }

    let(:valid_attributes) do
      { person_id: user,
        person_phone: { category: :home, label: 1, number: "1234567890" } }
    end

    let(:phone) do
      user.phones.create!(valid_attributes[:person_phone])
    end
    let(:update_attributes) do
      { id: phone,
        person_id: user,
        person_phone: { number: "6666666666" } }
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
          post :create, params: valid_attributes
          expect(response).to redirect_to root_path
        end
      end

      describe "GET #edit" do
        it "requires login" do
          get :edit, params: { id: phone, person_id: user }
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
          delete :destroy, params: { id: phone, person_id: user }
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

        it "assigns a new Person::Phone to @phone" do
          expect(assigns(:phone)).to be_a_new(Person::Phone)
        end

        it "renders the :new template" do
          expect(response).to render_template :new
        end
      end

      describe "POST #create" do
        context "with valid attributes" do
          it "saves the new phone in the database" do
            expect { post :create, params: valid_attributes }
              .to change(Person::Phone, :count).by(1)
          end

          it "redirects to people#show" do
            post :create, params: valid_attributes
            expect(response).to redirect_to user
          end
        end

        context "with invalid attributes" do
          it "is a pending example"
        end
      end

      describe "GET #edit" do
        before do
          get :edit, params: { id: phone, person_id: user }
        end

        it "assigns the requested phone to @phone" do
          expect(assigns(:phone)).to eq phone
        end

        it "renders the :edit template" do
          expect(response).to render_template :edit
        end
      end

      describe "PATCH #update" do
        context "with valid attributes" do
          it "redirects to people#show" do
            patch :update, params: update_attributes
            expect(response).to redirect_to user
          end
        end

        context "with invalid attributes" do
          it "is a pending example"
        end
      end

      describe "DELETE #destroy" do
        it "deletes the phone" do
          phone
          expect { delete :destroy, params: { id: phone, person_id: user } }
            .to change(Person::Phone, :count).by(-1)
        end

        it "redirects to people#show" do
          delete :destroy, params: { id: phone, person_id: user }
          expect(response).to redirect_to user
        end
      end
    end
  end
end
