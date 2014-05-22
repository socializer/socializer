require 'spec_helper'

module Socializer
  describe ActivityObject, type: :model do
    let(:activity_object) { build(:socializer_activity_object) }

    it 'has a valid factory' do
      expect(activity_object).to be_valid
    end

    context 'mass assignment' do
      it { expect(activity_object).to allow_mass_assignment_of(:scope) }
      it { expect(activity_object).to allow_mass_assignment_of(:object_ids) }
      it { expect(activity_object).to allow_mass_assignment_of(:activitable_id) }
      it { expect(activity_object).to allow_mass_assignment_of(:activitable_type) }
      it { expect(activity_object).to allow_mass_assignment_of(:like_count) }
      it { expect(activity_object).to allow_mass_assignment_of(:unread_notifications_count) }
      it { expect(activity_object).to allow_mass_assignment_of(:object_ids) }
    end

    context 'relationships' do
      it { expect(activity_object).to belong_to(:activitable) }
      it { expect(activity_object).to have_many(:notifications) }
      it { expect(activity_object).to have_many(:audiences) }
      it { expect(activity_object).to have_many(:activities).through(:audiences) }
      it { expect(activity_object).to have_many(:actor_activities) }
      it { expect(activity_object).to have_many(:object_activities) }
      it { expect(activity_object).to have_many(:target_activities) }
      it { expect(activity_object).to have_many(:notes) }
      it { expect(activity_object).to have_many(:comments) }
      it { expect(activity_object).to have_many(:groups) }
      it { expect(activity_object).to have_many(:circles) }
      it { expect(activity_object).to have_many(:ties) }
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
      it { expect(liked_activity_object.likes.size).to eq(1) }

      context 'and unliked' do
        before do
          liked_activity_object.unlike! liking_person
          liked_activity_object.reload
        end

        it { expect(liked_activity_object.like_count).to eq(0) }
        it { expect(liked_activity_object.likes.size).to eq(0) }
      end
    end

    it '#scope' do
      expect(activity_object).to respond_to(:scope)
    end

    context 'check activitable_type predicates' do
      context '#activity?' do
        let(:activity_object) { build(:socializer_activity_object_activity) }
        it { expect(activity_object.activity?).to be_truthy }
      end

      context '#circle?' do
        let(:activity_object) { build(:socializer_activity_object_circle) }
        it { expect(activity_object.circle?).to be_truthy }
      end

      context '#comment?' do
        let(:activity_object) { build(:socializer_activity_object_comment) }
        it { expect(activity_object.comment?).to be_truthy }
      end

      context '#group?' do
        let(:activity_object) { build(:socializer_activity_object_group) }
        it { expect(activity_object.group?).to be_truthy }
      end

      context '#note?' do
        let(:activity_object) { build(:socializer_activity_object) }
        it { expect(activity_object.note?).to be_truthy }
      end

      context '#person?' do
        let(:activity_object) { build(:socializer_activity_object_person) }
        it { expect(activity_object.person?).to be_truthy }
      end
    end

    context 'when an object is liked' do
      let(:activity_object) { create(:socializer_activity_object) }
      let(:liking_person) { create(:socializer_person) }

      before do
        activity_object.like! liking_person
        activity_object.reload
        liking_person.reload
      end

      it { expect(activity_object.like_count).to eq(1) }
      it { expect(activity_object.likes.size).to eq(1) }
      it { expect(liking_person.likes.count.size).to eq(1) }
      it { expect(liking_person.likes? activity_object).to be_truthy }

      context 'when an object is unliked' do
        before do
          activity_object.unlike! liking_person
          activity_object.reload
          liking_person.reload
        end

        it { expect(activity_object.like_count).to eq(0) }
        it { expect(activity_object.likes.size).to eq(0) }
        it { expect(liking_person.likes.count.size).to eq(0) }
        it { expect(liking_person.likes? activity_object).to be_falsey }
      end
    end

    context 'when an object is shared' do
      let(:activity_object) { create(:socializer_activity_object) }
      let(:actor) { create(:socializer_person) }
      let(:object_ids) { Socializer::Audience.privacy_level.find_value(:public).value.to_s.split(',') }
      let(:results) { activity_object.share!(actor_id: actor.guid, object_ids: object_ids, content: 'Share') }

      it { expect(results.success?).to eq(true) }
      it { expect(results.activity.actor_id).to eq(actor.guid) }
      it { expect(results.activity.activity_object_id).to eq(activity_object.id) }
      it { expect(results.activity.verb.name).to eq('share') }
      it { expect(results.activity.activity_field_content).to eq('Share') }

      context 'with no content' do
        let(:results) { activity_object.share!(actor_id: actor, object_ids: object_ids, content: nil) }
        it { expect(results.activity.activity_field_content).to eq(nil) }
      end
    end

    context '#increment_unread_notifications_count' do
      let(:activity_object) do
        create(:socializer_activity_object)
      end

      before do
        activity_object.increment_unread_notifications_count
        activity_object.reload
      end

      it { expect(activity_object.unread_notifications_count).to eq(1) }
    end

    %w(Person Activity Note Comment Group Circle).each do |type|
      # it format('is type of %s', type) do
      it "is type of #{type}" do
        activity_object.activitable_type = "Socializer::#{type}"
        expect(activity_object.send("#{type.downcase}?")).to be_truthy
      end
    end
  end
end
