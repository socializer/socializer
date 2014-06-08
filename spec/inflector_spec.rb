require 'spec_helper'

RSpec.describe ActiveSupport::Inflector::Inflections do
  context 'singularize' do
    it 'return the singular form of a word' do
      expect('ties'.singularize(:en)).to eq('tie')
      expect('Ties'.singularize(:en)).to eq('Tie')
      expect('activities'.singularize(:en)).to eq('activity')
      expect('Activities'.singularize(:en)).to eq('Activity')
    end

    it 'do not alter an already singular word' do
      expect('tie'.singularize(:en)).to eq('tie')
      expect('Tie'.singularize(:en)).to eq('Tie')
      expect('activity'.singularize(:en)).to eq('activity')
      expect('Activity'.singularize(:en)).to eq('Activity')
    end
  end
end
