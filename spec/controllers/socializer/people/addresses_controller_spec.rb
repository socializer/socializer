# frozen_string_literal: true

require "spec_helper"

module Socializer
  RSpec.describe People::AddressesController, type: :controller do
    routes { Socializer::Engine.routes }

    # Create a user nad address
    let(:user) { create(:person) }

    let(:valid_attributes) do
      { person_id: user,
        person_address: { category: :home,
                          line1: "282 Kevin Brook",
                          city: "Imogeneborough",
                          province_or_state: "California",
                          postal_code_or_zip: "12345",
                          country: "US" } }
    end

    let(:address) do
      user.addresses.create!(valid_attributes[:person_address])
    end

    let(:update_attributes) do
      { id: address,
        person_id: user,
        person_address: { label: "updated content" } }
    end

    describe "when not logged in" do
      describe "GET #new" do
        it "requires login" do
          get :new, params: { person_id: user}
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
          get :edit, params: { id: address, person_id: user }
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
          delete :destroy, params: { id: address, person_id: user }
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
          it "saves the new address in the database" do
            expect { post :create, params: valid_attributes }
              .to change(Person::Address, :count).by(1)
          end

          context "redirects to people#show" do
            before do
              post :create, params: valid_attributes
            end

            it { expect(response).to redirect_to user }
            it { expect(response).to have_http_status(:found) }
          end
        end

        context "with invalid attributes" do
          it "is a pending example"
        end
      end

      describe "GET #edit" do
        before do
          get :edit, params: { id: address, person_id: user }
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
        it "deletes the address" do
          address
          expect { delete :destroy, params: { id: address, person_id: user } }
            .to change(Person::Address, :count).by(-1)
        end

        context "redirects to people#show" do
          before do
            delete :destroy, params: { id: address, person_id: user }
          end

          it { expect(response).to redirect_to user }
          it { expect(response).to have_http_status(:found) }
        end
      end
    end
  end
end
