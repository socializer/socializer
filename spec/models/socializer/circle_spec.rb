require 'spec_helper'

module Socializer
  describe Circle do
    let(:circle) { build(:socializer_circle) }

    it 'has a valid factory' do
      expect(circle).to be_valid
    end

    context 'mass assignment' do
      it { expect(circle).to allow_mass_assignment_of(:name) }
      it { expect(circle).to allow_mass_assignment_of(:content) }
    end

    context 'relationships' do
      it { expect(circle).to belong_to(:activity_author) }
      it { expect(circle).to have_many(:ties) }
      it { expect(circle).to have_many(:activity_contacts).through(:ties) }
    end

    context 'validations' do
      it { expect(circle).to validate_presence_of(:name) }
      it { expect(create(:socializer_circle, name: 'Family')).to validate_uniqueness_of(:name).scoped_to(:author_id) }
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
