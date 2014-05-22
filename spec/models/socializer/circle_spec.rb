require 'spec_helper'

module Socializer
  describe Circle, :type => :model do
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

    context 'when adding a contact' do
      let(:circle_with_contacts) { create(:socializer_circle) }

      before do
        circle_with_contacts.add_contact(1)
        circle_with_contacts.reload
      end

      it { expect(circle_with_contacts.ties.size).to be(1) }
      it { expect(circle_with_contacts.contacts.size).to be(1) }

      context 'and removing it' do
        before do
          circle_with_contacts.remove_contact(1)
          circle_with_contacts.reload
        end

        it { expect(circle_with_contacts.ties.size).to be(0) }
        it { expect(circle_with_contacts.contacts.size).to be(0) }
      end
    end

    it '#author' do
      expect(circle).to respond_to(:author)
    end
  end
end
