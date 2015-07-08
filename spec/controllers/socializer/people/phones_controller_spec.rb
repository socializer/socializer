require "spec_helper"

module Socializer
  RSpec.describe People::PhonesController, type: :controller do
    routes { Socializer::Engine.routes }

    # Create a user and phone
    let(:user) { create(:socializer_person) }
    let(:valid_attributes) { { category: :home, label: 1, number: "1234567890" } }
    let(:phone) { user.phones.create!(valid_attributes) }

    describe "when not logged in" do
      describe "POST #create" do
        it "requires login" do
          post :create, person_phone: valid_attributes, person_id: user
          expect(response).to redirect_to root_path
        end
      end

      describe "PATCH #update" do
        it "requires login" do
          patch :update, id: phone, person_id: user, person_phone: { number: "6666666666" }
          expect(response).to redirect_to root_path
        end
      end

      describe "DELETE #destroy" do
        it "requires login" do
          delete :destroy, id: phone, person_id: user
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
          it "saves the new phone in the database" do
            expect { post :create, person_phone: valid_attributes, person_id: user }.to change(PersonPhone, :count).by(1)
          end

          it "redirects to people#show" do
            post :create, person_phone: valid_attributes, person_id: user
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
            patch :update, id: phone, person_id: user, person_phone: { number: "6666666666" }
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
          expect { delete :destroy, id: phone, person_id: user }.to change(PersonPhone, :count).by(-1)
        end

        it "redirects to people#show" do
          delete :destroy, id: phone, person_id: user
          expect(response).to redirect_to user
        end
      end
    end
  end
end
