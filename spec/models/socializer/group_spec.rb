require 'spec_helper'

module Socializer
  describe Group do
    let(:group) { build(:socializer_group) }

    it 'has a valid factory' do
      expect(group).to be_valid
    end

    context 'mass assignment' do
      it { expect(group).to allow_mass_assignment_of(:name) }
      it { expect(group).to allow_mass_assignment_of(:privacy_level) }
      it { expect(group).to allow_mass_assignment_of(:author_id) }
    end

    context 'relationships' do
      it { expect(group).to belong_to(:activity_author) }
      it { expect(group).to have_many(:memberships) }
      it { expect(group).to have_many(:activity_members).through(:memberships).conditions(socializer_memberships: { active: true }) }
    end

    context 'validations' do
      # TODO: Update factory to include relationshp
      # it { expect(group).to validate_presence_of(:activity_author) }
      it { expect(group).to validate_presence_of(:author_id) }
      it { expect(group).to validate_presence_of(:name) }
      it { expect(group).to validate_presence_of(:privacy_level) }
      it { expect(create(:socializer_group)).to validate_uniqueness_of(:name).scoped_to(:author_id) }
    end

    it { expect(enumerize(:privacy_level).in(:public, :restricted, :private).with_default(:public)) }

    it '#author' do
      expect(group).to respond_to(:author)
    end

    it '#members' do
      expect(group).to respond_to(:members)
    end

    it '#join' do
      expect(group).to respond_to(:join)
    end

    it '#invite' do
      expect(group).to respond_to(:invite)
    end

    it '#leave' do
      expect(group).to respond_to(:leave)
    end

    it '#member?' do
      expect(group).to respond_to(:member?)
    end

    context 'when group is public' do
      let(:public_group) { create(:socializer_group, privacy_level: 1) }
      let(:person) { create(:socializer_person) }

      before do
        public_group.save!
      end

      it '.public has 1 group' do
        expect(Socializer::Group.public.size).to eq(1)
      end

      it '.joinable has 1 group' do
        expect(Socializer::Group.joinable.size).to eq(1)
      end

      it 'is has the right privacy level' do
        expect(public_group.privacy_level.public?).to be_true
      end

      it 'member? is false' do
        expect(public_group.member?(person)).to be_false
      end

      context 'and a person joins it' do
        before do
          public_group.join(person)
          @membership = Membership.find_by(member_id: person.guid, group_id: public_group.id)
        end

        it 'creates an active membership' do
          expect(@membership.active).to be_true
        end

        it 'member? is true' do
          expect(public_group.member?(person)).to be_true
        end

        it 'has 1 member' do
          expect(public_group.members.size).to eq(1)
        end

        context 'and leaving' do
          before do
            public_group.leave(person)
            @membership = Membership.find_by(member_id: person.guid, group_id: public_group.id)
          end

          it 'destroys the membership' do
            expect(@membership).to be_nil
          end

          it 'has 0 member' do
          expect(public_group.members.size).to eq(0)
        end
        end
      end
    end

    context 'when group is restricted' do
      let(:restricted_group) { create(:socializer_group, privacy_level: 2) }
      let(:person) { create(:socializer_person) }

      before do
        restricted_group.save!
      end

      it '.restricted has 1 group' do
        expect(Socializer::Group.restricted.size).to eq(1)
      end

      it '.joinable has 1 group' do
        expect(Socializer::Group.joinable.size).to eq(1)
      end

      it 'is has the right privacy level' do
        expect(restricted_group.privacy_level.restricted?).to be_true
      end

      context 'and a person joins it' do
        before do
          restricted_group.join(person)
          @membership = Membership.find_by(member_id: person.guid, group_id: restricted_group.id)
        end

        it 'creates an inactive membership' do
          expect(@membership.active).to be_false
        end
      end
    end

    context 'when group is private' do
      let(:private_group) { create(:socializer_group, privacy_level: 3) }
      let(:person) { create(:socializer_person) }

      before do
        private_group.save!
      end

      it '.private has 1 group' do
        expect(Socializer::Group.private.size).to eq(1)
      end

      it 'is has the right privacy level' do
        expect(private_group.privacy_level.private?).to be_true
      end

      it 'cannot be joined' do
        expect { private_group.join(person) }.to raise_error
      end

      context 'and a person gets invited' do
        before do
          private_group.invite(person)
          @membership = Membership.find_by(member_id: person.guid, group_id: private_group.id)
        end

        it 'creates an inactive membership' do
          expect(@membership.active).to be_false
        end
      end
    end

    context 'when inviting a person' do
      let(:person) { create(:socializer_person) }

      before do
        group.invite(person)
        @membership = Membership.find_by(member_id: person.guid, group_id: group.id)
      end

      it 'creates an inactive membership' do
        expect(@membership.active).to be_false
      end
    end

    context 'when having no member' do
      let(:group_without_members) { create(:socializer_group, privacy_level: 3) }

      before do
        # the author is added as a member, so remove it first
        group_without_members.memberships.first.destroy
      end

      it 'can be deleted' do
        expect { group_without_members.destroy }.not_to raise_error
      end
    end

    context 'when having at least one member' do
      let(:group_with_members) { create(:socializer_group, privacy_level: 3) }

      it 'cannot be deleted' do
        expect { group_with_members.destroy }.to raise_error
      end
    end

  end
end
