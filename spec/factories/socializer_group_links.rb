# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :socializer_group_link, class: Socializer::GroupLink do
    group_id 1
    label 'test'
    url 'http://test.org'
  end
end
