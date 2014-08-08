require 'rails_helper'

module Socializer
  RSpec.describe AudienceList, type: :service do
    context 'when the person argument is nil' do
      context '.new should raise an ArgumentError' do
        let(:audience_list) { AudienceList.new(person: nil, query: nil) }
        it { expect { audience_list }.to raise_error(ArgumentError) }
      end

      context '.perform should raise an ArgumentError' do
        let(:audience_list) { AudienceList.perform(person: nil, query: nil) }
        it { expect { audience_list }.to raise_error(ArgumentError) }
      end
    end

    # TODO: Implement more specific tests
    #       check items in the returned array: icons, circles, groups
    context '.perform' do
      it 'is a pending example'
      let(:person) { create(:socializer_person) }
      let(:circles) { create(:socializer_person_circles) }
      let(:groups) { create(:socializer_person_groups) }

      context 'with no query' do
        it { expect(AudienceList.new(person: person, query: nil).perform).to be_kind_of(Array) }
      end

      context 'with query' do
        it { expect(AudienceList.new(person: person, query: 'n').perform).to be_kind_of(Array) }
      end
    end
  end
end
