require 'rails_helper'

module Socializer
  RSpec.describe PersonDecorator, type: :decorator do
    context 'birthdate' do
      let(:person) { build(:socializer_person) }
      let(:decorated_person) { PersonDecorator.new(person) }

      context 'not specified' do
        it { expect(decorated_person.birthday).to be nil }
      end

      context 'specified' do
        let(:person) { build(:socializer_person, birthdate: Time.now - 10.years) }

        it { expect(decorated_person.birthday).to eq person.birthdate.to_s(:long_ordinal) }
      end
    end
  end
end
