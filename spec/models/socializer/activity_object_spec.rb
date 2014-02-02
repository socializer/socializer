require 'spec_helper'

module Socializer
  describe ActivityObject do
    let(:activity_object) { build(:socializer_activity_object) }

    it 'has a valid factory' do
      expect(activity_object).to be_valid
    end

    context 'relationships' do
      it { expect(activity_object).to have_many(:notifications) }
    end

    it '#scope' do
      expect(activity_object).to respond_to(:scope)
    end

    it '#like_count' do
      expect(activity_object).to respond_to(:like_count)
    end

    it '#note?' do
      expect(activity_object).to respond_to(:note?)
    end

    it '#activity?' do
      expect(activity_object).to respond_to(:activity?)
    end

    it '#comment?' do
      expect(activity_object).to respond_to(:comment?)
    end

    it '#person?' do
      expect(activity_object).to respond_to(:person?)
    end

    it '#group?' do
      expect(activity_object).to respond_to(:group?)
    end

    it '#circle?' do
      expect(activity_object).to respond_to(:circle?)
    end

    it '#likes' do
      expect(activity_object).to respond_to(:likes)
    end

    it '#like!' do
      expect(activity_object).to respond_to(:like!)
    end

    it '#unlike!' do
      expect(activity_object).to respond_to(:unlike!)
    end

    it '#share!' do
      expect(activity_object).to respond_to(:share!)
    end

    %w(Person Activity Note Comment Group Circle).each do |type|

      it sprintf('is type of %s', type) do
        activity_object.activitable_type = "Socializer::#{type}"
        expect(eval("activity_object.#{type.downcase}?")).to be_true
      end

    end

  end
end
