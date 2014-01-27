require 'spec_helper'

module Socializer
  describe Group do
    it { should allow_mass_assignment_of(:name) }
    it { should allow_mass_assignment_of(:privacy_level) }

    it { should enumerize(:privacy_level).in(:public, :restricted, :private).with_default(:public) }

    it 'has a valid factory' do
      expect(create(:socializer_group)).to be_valid
    end

    it 'is invalid without an author' do
      expect(build(:socializer_group, author_id: nil)).to be_invalid
    end

    it 'is invalid without a name' do
      expect(build(:socializer_group, name: nil)).to be_invalid
    end

    it 'is invalid without a privacy level' do
      expect(build(:socializer_group, privacy_level: nil)).to be_invalid
    end

    it '#author' do
      expect(build(:socializer_group)).to respond_to(:author)
    end

    it '#members' do
      expect(build(:socializer_group)).to respond_to(:members)
    end

    it '#join' do
      expect(build(:socializer_group)).to respond_to(:join)
    end

    it '#invite' do
      expect(build(:socializer_group)).to respond_to(:invite)
    end

    it '#leave' do
      expect(build(:socializer_group)).to respond_to(:leave)
    end

    it '#member?' do
      expect(build(:socializer_group)).to respond_to(:member?)
    end

    context 'when group is public' do
      let(:group) { create(:socializer_group, privacy_level: 1) }
      let(:person) { create(:socializer_person) }

      it 'is has the right privacy level' do
        expect(group.privacy_level.public?).to be_true
      end

      it 'member? is false' do
        expect(group.member?(person)).to be_false
      end

      context 'and a person joins it' do
        before do
          group.join(person)
          @membership = Membership.find_by(member_id: person.guid, group_id: group.id)
        end

        it 'creates an active membership' do
          expect(@membership.active).to be_true
        end

        it 'member? is true' do
          expect(group.member?(person)).to be_true
        end

        context 'and leaving' do
          before do
            group.leave(person)
            @membership = Membership.find_by(member_id: person.guid, group_id: group.id)
          end
          it 'destroys the membership' do
            expect(@membership).to be_nil
          end
        end
      end
    end

    context 'when group is restricted' do
      let(:group) { create(:socializer_group, privacy_level: 2) }
      let(:person) { create(:socializer_person) }

      it 'is has the right privacy level' do
        expect(group.privacy_level.restricted?).to be_true
      end

      context 'and a person joins it' do
        before do
          group.join(person)
          @membership = Membership.find_by(member_id: person.guid, group_id: group.id)
        end

        it 'creates an inactive membership' do
          expect(@membership.active).to be_false
        end
      end
    end

    context 'when group is private' do
      let(:group) { create(:socializer_group, privacy_level: 3) }
      let(:person) { create(:socializer_person) }

      it 'is has the right privacy level' do
        expect(group.privacy_level.private?).to be_true
      end

      context 'and a person joins it' do
        it 'raises an error' do
          expect { group.join(person) }.to raise_error
        end
      end
    end

    context 'when inviting a person' do
      let(:group) { create(:socializer_group) }
      let(:person) { create(:socializer_person) }

      before do
        group.invite(person)
        @membership = Membership.find_by(member_id: person.guid, group_id: group.id)
      end

      it 'creates an inactive membership' do
        expect(@membership.active).to be_false
      end
    end

  end
end
