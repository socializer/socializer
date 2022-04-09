# frozen_string_literal: true

require "rails_helper"

module Socializer
  module Activities
    RSpec.describe SharesController, type: :controller do
      routes { Socializer::Engine.routes }

      # Create a user and a note to share
      let(:user) { create(:person) }
      let(:note) { create(:note) }

      let(:object_ids) do
        Socializer::Audience.privacy.find_value(:public).value
      end

      let(:valid_attributes) do
        { id: note,
          share: { content: "",
                   object_ids:,
                   activity_id: note.guid } }
      end

      let(:invalid_attributes) do
        { id: note,
          share: { content: "",
                   object_ids:,
                   activity_id: nil } }
      end

      context "when not logged in" do
        describe "GET #new" do
          it "requires login" do
            get :new, params: { id: note.guid }
            expect(response).to redirect_to root_path
          end
        end

        describe "POST #create" do
          it "requires login" do
            post :create, params: valid_attributes
            expect(response).to redirect_to root_path
          end
        end
      end

      context "when logged in" do
        # Setting the current user
        before { cookies.signed[:user_id] = user.guid }

        specify { is_expected.to use_before_action(:authenticate_user) }

        describe "GET #new" do
          # Visit the new page
          before { get :new, params: { id: note.guid } }

          it "renders the :new template" do
            expect(response).to render_template :new
          end
        end

        describe "POST #create" do
          context "with valid attributes" do
            before do
              post :create, params: valid_attributes
            end

            let(:message) do
              t("socializer.model.create",
                model: "Note")
            end

            it "redirects to circles#contacts" do
              expect(response).to redirect_to activities_path
            end

            specify { is_expected.to set_flash[:notice].to(message) }
          end

          context "with invalid attributes" do
            it "does not save the new share in the database" do
              expect { post :create, params: invalid_attributes }
                .not_to change(Activity, :count)
            end

            it "re-renders the :new template" do
              post :create, params: invalid_attributes
              expect(response).to render_template :new
            end
          end
        end
      end
    end
  end
end
