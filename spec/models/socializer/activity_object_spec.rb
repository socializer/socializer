require 'spec_helper'

module Socializer
  describe ActivityObject do
    let(:activity_object) { build(:socializer_activity_object) }

    it 'has a valid factory' do
      expect(activity_object).to be_valid
    end

    context 'mass assignment' do
      assignments = [:scope, :object_ids, :activitable_id, :activitable_type,
                     :like_count, :unread_notifications_count, :object_ids]
      assignments.each do |assign|
        it { expect(activity_object).to allow_mass_assignment_of(assign) }
      end
    end

    context 'relationships' do
      has_many_rel = [:notifications, :audiences, :actor_activities, :object_activities,
                      :target_activities, :notes, :comments, :groups, :circles, :ties]
      has_many_rel.each do |relation|
        it { expect(activity_object).to have_many(relation) }
      end

      it { expect(activity_object).to belong_to(:activitable) }
      it { expect(activity_object).to have_many(:activities).through(:audiences) }
      it { expect(activity_object).to have_many(:memberships).conditions(active: true) }
    end

    context 'when liked' do
      let(:liking_person) { create(:socializer_person) }
      let(:liked_activity_object) { create(:socializer_activity_object) }

      before do
        liked_activity_object.like! liking_person
        liked_activity_object.reload
      end

      it { expect(liked_activity_object.like_count).to eq(1) }

      context 'and unliked' do
        before do
          liked_activity_object.unlike! liking_person
          liked_activity_object.reload
        end

        it { expect(liked_activity_object.like_count).to eq(0) }
      end
    end

    context 'attribute accessors' do
      accessors = [:scope, :like_count, :note?, :activity?, :comment?, :person?,
                   :group?, :circle?, :likes, :like!, :unlike!, :share!]

      accessors.each do |attr|
        it { expect(activity_object).to respond_to(attr) }
      end
    end

    %w(Person Activity Note Comment Group Circle).each do |type|

      it sprintf('is type of %s', type) do
        activity_object.activitable_type = "Socializer::#{type}"
        expect(activity_object.send("#{type.downcase}?")).to be_true
      end

    end

  end
end
