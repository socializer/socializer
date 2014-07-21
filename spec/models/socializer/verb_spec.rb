require 'rails_helper'

module Socializer
  RSpec.describe Verb, type: :model do
    let(:verb) { build(:socializer_verb) }

    it 'has a valid factory' do
      expect(verb).to be_valid
    end

    context 'mass assignment' do
      it { is_expected.to allow_mass_assignment_of(:display_name) }
    end

    context 'relationships' do
      it { is_expected.to have_many(:activities) }
    end

    context 'validations' do
      it { is_expected.to validate_presence_of(:display_name) }
      it { is_expected.to validate_uniqueness_of(:display_name) }
    end

    context 'scopes' do
      context 'by_display_name' do
        before { create(:socializer_verb, display_name: 'post') }
        let(:result) { Verb.by_display_name('post') }

        it { expect(result).to be_kind_of(ActiveRecord::Relation) }
        it { expect(result.first.name).to eq('post') }

        context 'when the name is not found' do
          let(:result) { Verb.by_display_name('none') }

          it { expect(result).to be_kind_of(ActiveRecord::Relation) }
          it { expect(result.present?).to be(false) }
        end
      end
    end
  end
end
