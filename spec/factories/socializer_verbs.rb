# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :socializer_verb, :class => 'Verb' do
    name "post"
  end
end
