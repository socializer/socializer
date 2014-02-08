require 'spec_helper'

module Socializer
  describe SharesController do
    pending "add test for action #create to #{__FILE__}"

    # before and after are necessary since shares_controller isn't accessible directly in routes.
    before(:all) do
      Rails.application.routes.draw { get ':controller(/:action)'  }
    end
    after(:all) do
      Rails.application.reload_routes!
    end

    # Create an activity_object to share
    let(:note) { create(:socializer_note) }

    describe 'GET #new' do
      # Visit the new page
      before { get :new, :id => note.activity_object.id }

      it 'should return an activity object' do
        expect(assigns(:activity_object)).to eq(note.activity_object)
      end

      it 'should return an share object' do
        expect(assigns(:share)).to eq(note)
      end
    end

    describe 'GET #create' do


    end

  end
end
