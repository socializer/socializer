require 'spec_helper'

module Socializer
  RSpec.describe People::EducationsController, type: :controller do
    routes { Socializer::Engine.routes }

    # Create a user nad education
    let(:user) { create(:socializer_person) }
    let(:valid_attributes) { { school_name: 'Test School', major_or_field_of_study: 'Student' } }
    let(:education) { user.educations.create!(valid_attributes) }

    # Setting the current user
    before { cookies[:user_id] = user.guid }

    it { should use_before_action(:authenticate_user) }

    describe 'POST #create' do
      context 'with valid attributes' do
        it 'saves the new education in the database' do
          expect { post :create, person_education: valid_attributes, person_id: user }.to change(PersonEducation, :count).by(1)
        end

        it 'redirects to people#show' do
          post :create, person_education: valid_attributes, person_id: user
          expect(response).to redirect_to user
        end
      end

      context 'with invalid attributes' do
        it 'is a pending example'
      end
    end

    describe 'PATCH #update' do
      context 'with valid attributes' do
        it 'redirects to people#show' do
          patch :update, id: education, person_id: user, person_education: { label: 'updated content' }
          expect(response).to redirect_to user
        end
      end

      context 'with invalid attributes' do
        it 'is a pending example'
      end
    end

    describe 'DELETE #destroy' do
      it 'deletes the education' do
        education
        expect { delete :destroy, id: education, person_id: user }.to change(PersonEducation, :count).by(-1)
      end

      it 'redirects to people#show' do
        delete :destroy, id: education, person_id: user
        expect(response).to redirect_to user
      end
    end
  end
end
