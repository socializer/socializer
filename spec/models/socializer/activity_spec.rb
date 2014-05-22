require 'spec_helper'

module Socializer
  describe Activity, :type => :model do
    let(:activity) { build(:socializer_activity) }

    it 'has a valid factory' do
      expect(activity).to be_valid
    end

    context 'mass assignment' do
      it { expect(activity).to allow_mass_assignment_of(:verb) }
      it { expect(activity).to allow_mass_assignment_of(:circles) }
      it { expect(activity).to allow_mass_assignment_of(:actor_id) }
      it { expect(activity).to allow_mass_assignment_of(:activity_object_id) }
      it { expect(activity).to allow_mass_assignment_of(:target_id) }
    end

    context 'relationships' do
      it { expect(activity).to belong_to(:parent) }
      it { expect(activity).to belong_to(:activitable_actor) }
      it { expect(activity).to belong_to(:activitable_object) }
      it { expect(activity).to belong_to(:activitable_target) }
      it { expect(activity).to belong_to(:verb) }
      it { expect(activity).to have_one(:activity_field) }
      it { expect(activity).to have_many(:audiences) }
      it { expect(activity).to have_many(:activity_objects) }
      it { expect(activity).to have_many(:children) }
      it { expect(activity).to have_many(:notifications) }
    end

    context 'validations' do
      it { expect(activity).to validate_presence_of(:verb) }
    end

    it { expect(activity).to delegate_method(:activity_field_content).to(:activity_field).as(:content) }

    # TODO: Test activity.comments? == true
    it { expect(activity.comments?).to eq(false) }
  end
end
