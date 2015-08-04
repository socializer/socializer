require "rails_helper"

module Socializer
  module Activities
    RSpec.describe SharesController, type: :controller do
      routes { Socializer::Engine.routes }

      # Create a user and a note to share
      let(:user) { create(:person) }
      let(:note) { create(:note) }

      let(:object_ids) do
        Socializer::Audience.privacy.find_value(:public).value.split(",")
      end

      let(:valid_attributes) do
        { id: note,
          share: { content: "",
                   object_ids: object_ids,
                   activity_id: note.guid
                 }
        }
      end

      describe "when not logged in" do
        describe "GET #new" do
          it "requires login" do
            get :new, id: note.guid
            expect(response).to redirect_to root_path
          end
        end

        describe "POST #create" do
          it "requires login" do
            post :create, valid_attributes
            expect(response).to redirect_to root_path
          end
        end
      end

      describe "when logged in" do
        # Setting the current user
        before { cookies.signed[:user_id] = user.guid }

        it { should use_before_action(:authenticate_user) }

        describe "GET #new" do
          # Visit the new page
          before { get :new, id: note.guid }

          it "return an activity object" do
            expect(assigns(:activity_object)).to eq(note.activity_object)
          end

          it "return an share object" do
            expect(assigns(:share)).to eq(note)
          end

          it "renders the :new template" do
            expect(response).to render_template :new
          end
        end

        describe "POST #create" do
          context "with valid attributes" do
            before do
              post :create, valid_attributes
            end

            let(:message) do
              t("socializer.model.create",
                model: "Note")
            end

            it "redirects to circles#contacts" do
              expect(response).to redirect_to activities_path
            end

            # FIXME: Should accept a symbol in next RC or release
            it { should set_flash["notice"].to(message) }
          end

          context "with invalid attributes" do
            it "is a pending example"
            # it "re-renders the :new template" do
            #   post :create, invalid_attributes
            #   expect(response).to render_template :new
            # end
          end
        end
      end
    end
  end
end
