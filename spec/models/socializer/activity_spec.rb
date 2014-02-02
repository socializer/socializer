require 'spec_helper'

module Socializer
  describe Activity do
    let(:activity) { build(:socializer_activity) }

    it 'has a valid factory' do
      expect(activity).to be_valid
    end

    context 'relationships' do
      it { expect(activity).to have_many(:notifications) }
    end

  end
end
