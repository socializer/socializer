require 'spec_helper'

module Socializer
  describe Activity do
    let(:activity) { build(:socializer_activity) }

    it 'has a valid factory' do
      expect(activity).to be_valid
    end

    context 'relationships' do
      relations = [:audiences, :notifications, :activity_objects, :children]
      relations.each do |relation|
        it { expect(activity).to have_many(relation) }
      end
    end

  end
end
