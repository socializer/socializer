require 'spec_helper'

module Socializer
  RSpec.describe Activity, type: :model do
    let(:activity) { build(:socializer_activity) }

    it 'has a valid factory' do
      expect(activity).to be_valid
    end

    context 'mass assignment' do
      it { is_expected.to allow_mass_assignment_of(:verb) }
      it { is_expected.to allow_mass_assignment_of(:circles) }
      it { is_expected.to allow_mass_assignment_of(:actor_id) }
      it { is_expected.to allow_mass_assignment_of(:activity_object_id) }
      it { is_expected.to allow_mass_assignment_of(:target_id) }
    end

    context 'relationships' do
      it { is_expected.to belong_to(:parent) }
      it { is_expected.to belong_to(:activitable_actor) }
      it { is_expected.to belong_to(:activitable_object) }
      it { is_expected.to belong_to(:activitable_target) }
      it { is_expected.to belong_to(:verb) }
      it { is_expected.to have_one(:activity_field) }
      it { is_expected.to have_many(:audiences) }
      it { is_expected.to have_many(:activity_objects) }
      it { is_expected.to have_many(:children) }
      it { is_expected.to have_many(:notifications) }
    end

    context 'validations' do
      it { is_expected.to validate_presence_of(:verb) }
    end

    it { is_expected.to delegate_method(:activity_field_content).to(:activity_field).as(:content) }

    # TODO: Test activity.comments? == true
    it { expect(activity.comments?).to eq(false) }
  end
end
