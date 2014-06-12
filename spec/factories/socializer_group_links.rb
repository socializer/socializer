# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :socializer_group_link, class: Socializer::GroupLink do
    label 'test'
    url 'http://test.org'
    association :group, factory: :socializer_group
  end
end
