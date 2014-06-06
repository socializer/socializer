require 'spec_helper'

module Socializer
  RSpec.describe Circle, type: :model do
    let(:circle) { build(:socializer_circle) }

    it 'has a valid factory' do
      expect(circle).to be_valid
    end

    context 'mass assignment' do
      it { is_expected.to allow_mass_assignment_of(:name) }
      it { is_expected.to allow_mass_assignment_of(:content) }
    end

    context 'relationships' do
      it { is_expected.to belong_to(:activity_author) }
      it { is_expected.to have_many(:ties) }
      it { is_expected.to have_many(:activity_contacts).through(:ties) }
    end

    context 'validations' do
      it { is_expected.to validate_presence_of(:name) }
      it { is_expected.to validate_uniqueness_of(:name).scoped_to(:author_id) }
    end

    context '.audience_list' do
      it 'is a pending example'
      it { expect { Circle.audience_list }.to raise_error(ArgumentError) }

      context 'current user but no query' do
        let(:current_user) { create(:socializer_person) }
        it { expect { Circle.audience_list(current_user) }.to raise_error(ArgumentError) }
        # TODO: Test return values
        it { expect(Circle.audience_list(current_user, nil)).to be_kind_of(ActiveRecord::AssociationRelation) }
        it { expect(Circle.audience_list(current_user, 't')).to be_kind_of(ActiveRecord::AssociationRelation) }
      end
    end

    context 'author' do
      it 'is a pending example'
      # it { expect(circle.author).to be_kind_of(Socializer::Person) }
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

    it { is_expected.to respond_to(:author) }
  end
end
