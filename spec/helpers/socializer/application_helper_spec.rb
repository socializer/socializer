require 'rails_helper'

module Socializer
  RSpec.describe ApplicationHelper, type: :helper do
    context '#signin_path' do
      it 'returns the signin path for the given provider' do
        expect(helper.signin_path(:facebook)).to eq('/auth/facebook')
      end
    end
  end
end
