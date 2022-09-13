# frozen_string_literal: true

require "rails_helper"

module Socializer
  RSpec.describe TiesController, type: :controller do
    routes { Socializer::Engine.routes }

    # Create a user, a circle, a tie, and valid_attributes
    let(:user) { create(:person) }
    let(:circle) { create(:circle) }

    let(:tie_attributes) do
      { activity_contact: user.activity_object, circle: }
    end

    let(:tie) do
      create(:tie, tie_attributes)
    end

    let(:valid_attributes) do
      { tie: { circle_id: circle.id, contact_id: user.activity_object.id } }
    end

    let(:invalid_attributes) do
      { tie: { circle_id: nil, contact_id: user.activity_object.id } }
    end

    context "when not logged in" do
      describe "POST #create" do
        it "requires login" do
          post :create, params: valid_attributes, format: :js
          expect(response).to redirect_to root_path
        end
      end

      describe "DELETE #destroy" do
        it "requires login" do
          delete :destroy, params: { id: tie }
          expect(response).to redirect_to root_path
        end
      end
    end

    context "when logged in" do
      # Setting the current user
      before { cookies.signed[:user_id] = user.guid }

      specify { is_expected.to use_before_action(:authenticate_user) }

      describe "POST #create" do
        before do
          request.env["HTTP_ACCEPT"] = "application/javascript"
        end

        context "with valid attributes" do
          it "saves the new group in the database" do
            expect { post :create, params: valid_attributes, format: :js }
              .to change(Tie, :count).by(1)
          end

          describe "it renders the :create template" do
            before do
              post :create, params: valid_attributes, format: :js
            end

            specify { expect(response).to have_http_status(:ok) }
            specify { expect(response).to render_template(:create) }
          end
        end

        context "with invalid attributes" do
          it "is pending", pending: true
          # it "does not save the new address in the database" do
          #   expect { post :create, params: invalid_attributes, format: :js }
          #     .not_to change(Tie, :count)
          # end
          #
          # specify { expect(response).to have_http_status(:ok) }
        end
      end

      describe "DELETE #destroy" do
        it "deletes the tie" do
          tie
          expect { delete :destroy, params: { id: tie } }
            .to change(Tie, :count).by(-1)
        end

        describe "it redirects to circles#show" do
          before do
            delete :destroy, params: { id: tie }
          end

          specify { expect(response).to redirect_to circle }
          specify { expect(response).to have_http_status(:found) }
        end
      end
    end
  end
end
