require 'spec_helper'

describe ActiveSupport::Inflector::Inflections do
  context 'singularize' do
    it 'should  return the singular form of a word' do
      'ties'.singularize(:en).should eq('tie')
      'Ties'.singularize(:en).should eq('Tie')
      'activities'.singularize(:en).should eq('activity')
      'Activities'.singularize(:en).should eq('Activity')
    end

    it 'should not alter an already singular word' do
      'tie'.singularize(:en).should eq('tie')
      'Tie'.singularize(:en).should eq('Tie')
      'activity'.singularize(:en).should eq('activity')
      'Activity'.singularize(:en).should eq('Activity')
    end
  end
end
