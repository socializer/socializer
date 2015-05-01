require 'rails_helper'

module Socializer
  RSpec.describe Groups::OwnershipsController, type: :routing do
    routes { Socializer::Engine.routes }

    describe 'routing' do
      it 'routes to #index' do
        expect(get: '/groups/ownerships').to route_to('socializer/groups/ownerships#index')
      end

      it 'does not route to #new' do
        expect(get: '/groups/ownerships/new').to_not be_routable
      end

      it 'does not route to #show' do
        expect(get: '/groups/ownerships/show').to_not be_routable
      end

      it 'does not route to #edit' do
        expect(get: '/groups/ownerships/1/edit').to_not be_routable
      end

      it 'does not route to #create' do
        expect(post: '/groups/ownerships').to_not be_routable
      end

      it 'does not route to #update' do
        expect(patch: '/groups/ownerships/1').to_not be_routable
        expect(put: '/groups/ownerships/1').to_not be_routable
      end

      it 'does not route to #destroy' do
        expect(delete: '/groups/ownerships/1').to_not be_routable
      end
    end
  end
end
