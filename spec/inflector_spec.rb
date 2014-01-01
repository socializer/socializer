require 'spec_helper'

describe ActiveSupport::Inflector::Inflections do
  context 'singularize' do
    it 'should  return the singular form of a word' do
      'ties'.singularize(:en).should == 'tie'
      'Ties'.singularize(:en).should == 'Tie'
      'activities'.singularize(:en).should == 'activity'
      'Activities'.singularize(:en).should == 'Activity'
    end

    it 'should not alter an already singular word' do
      'tie'.singularize(:en).should == 'tie'
      'Tie'.singularize(:en).should == 'Tie'
      'activity'.singularize(:en).should == 'activity'
      'Activity'.singularize(:en).should == 'Activity'
    end
  end
end
