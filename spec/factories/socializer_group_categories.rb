# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :socializer_group_category, class: Socializer::GroupCategory do
    display_name "category"
    association :group, factory: :socializer_group
  end
end
