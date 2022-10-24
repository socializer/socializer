# frozen_string_literal: true

require "rails_helper"

module Socializer
  RSpec.describe NotificationsController do
    routes { Socializer::Engine.routes }

    # Create a user and notification
    let(:user) { create(:person) }
    let(:notification) { create(:notification) }

    context "when not logged in" do
      describe "GET #index" do
        it "requires login" do
          get :index
          expect(response).to redirect_to root_path
        end
      end

      describe "GET #show" do
        it "requires login" do
          get :show, params: { id: notification }
          expect(response).to redirect_to root_path
        end
      end
    end

    context "when logged in" do
      # Setting the current user
      before { cookies.signed[:user_id] = user.guid }

      specify { is_expected.to use_before_action(:authenticate_user) }

      describe "GET #index" do
        let(:params) do
          { note: { content: "Test",
                    object_ids: "public",
                    activity_verb: "post" } }
        end

        let(:note) do
          user.activity_object.notes.create!(params[:note])
        end

        let(:activity) do
          Activity.find_by(activity_object_id: note.guid).decorate
        end

        context "when unread notifications are 0" do
          before do
            get :index
          end

          it "assigns @notifications" do
            expect(assigns(:notifications))
              .to match_array(activity.notifications)
          end

          it "renders the :index template" do
            expect(response).to render_template :index
          end

          it "returns http success" do
            get :index
            expect(response).to have_http_status(:success)
          end
        end

        context "when unread notifications are > 0" do
          it "reset to 0" do
            activity_object = user.activity_object
            activity_object.update!(unread_notifications_count: 10)
            get :index
            expect(activity_object.reload.unread_notifications_count).to eq(0)
          end
        end
      end

      describe "GET #show" do
        before do
          get :show, params: { id: notification }
        end

        let(:activities_path) do
          activity_activities_path(activity_id: notification.activity.id)
        end

        it "marks the notification as read" do
          expect(notification.reload.read).to be true
        end

        it "renders the show template" do
          expect(response).to redirect_to activities_path
        end
      end
    end
  end
end
