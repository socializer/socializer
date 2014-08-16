require 'rails_helper'

module Socializer
  RSpec.describe ActivityCreator, type: :service do
    context 'validations' do
      it { is_expected.to validate_presence_of(:actor_id) }
      it { is_expected.to validate_presence_of(:activity_object_id) }
      it { is_expected.to validate_presence_of(:verb) }
    end
  end
end
