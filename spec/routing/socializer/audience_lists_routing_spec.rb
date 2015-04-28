require 'rails_helper'

module Socializer
  RSpec.describe AudienceListsController, type: :routing do
    routes { Socializer::Engine.routes }

    describe 'routing' do
      it 'routes to #index' do
        expect(get: '/audience_lists', format: :json).to route_to('socializer/audience_lists#index')
      end

      it 'does not route to #new' do
        expect(get: '/audience_lists/new').to_not be_routable
      end

      it 'does not route to #show' do
        expect(get: '/audience_lists/1').to_not be_routable
      end

      it 'does not route to #edit' do
        expect(get: '/audience_lists/1/edit').to_not be_routable
      end

      it 'does not route to #create' do
        expect(post: '/audience_lists').to_not be_routable
      end

      it 'does not route to #update' do
        expect(patch: '/audience_lists/1').to_not be_routable
      end

      it 'does not route to #destroy' do
        expect(delete: '/audience_lists/1').to_not be_routable
      end
    end
  end
end
