require "spec_helper"

module Socializer
  RSpec.describe People::AddressesController, type: :controller do
    routes { Socializer::Engine.routes }

    # Create a user nad address
    let(:user) { create(:person) }

    let(:valid_attributes) do
      {
        person_id: user,
        person_address: { category: :home, postal_code_or_zip: "12345" }
      }
    end

    let(:address) do
      user.addresses.create!(valid_attributes[:person_address])
    end

    let(:update_attributes) do
      { id: address,
        person_id: user,
        person_address: { label: "updated content" }
      }
    end

    describe "when not logged in" do
      describe "POST #create" do
        it "requires login" do
          post :create, valid_attributes
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
          delete :destroy, id: address, person_id: user
          expect(response).to redirect_to root_path
        end
      end
    end

    describe "when logged in" do
      # Setting the current user
      before { cookies.signed[:user_id] = user.guid }

      it { should use_before_action(:authenticate_user) }

      describe "POST #create" do
        context "with valid attributes" do
          it "saves the new address in the database" do
            expect { post :create, valid_attributes }
              .to change(PersonAddress, :count).by(1)
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
        it "deletes the address" do
          address
          expect { delete :destroy, id: address, person_id: user }
            .to change(PersonAddress, :count).by(-1)
        end

        it "redirects to people#show" do
          delete :destroy, id: address, person_id: user
          expect(response).to redirect_to user
        end
      end
    end
  end
end
