require 'spec_helper'

module Socializer
  describe Circle do
    let(:circle) { build(:socializer_circle) }

    it 'has a valid factory' do
      expect(circle).to be_valid
    end

    it 'is invalid without a name' do
      expect(build(:socializer_circle, name: nil)).to be_invalid
    end

    it '#name' do
      expect(circle).to respond_to(:name)
    end

    it '#ties' do
      expect(circle).to respond_to(:ties)
    end

    it '#author' do
      expect(circle).to respond_to(:author)
    end

    it '#contacts' do
      expect(circle).to respond_to(:contacts)
    end

    it '#add_contact' do
      expect(circle).to respond_to(:add_contact)
    end

    it '#remove_contact' do
      expect(circle).to respond_to(:remove_contact)
    end
  end
end
