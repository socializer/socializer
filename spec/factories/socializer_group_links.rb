# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :group_link, class: Socializer::Group::Link do
    label "test"
    url "http://test.org"
    association :group, factory: :group
  end
end
