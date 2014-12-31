# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :socializer_membership, class: Socializer::Membership do
    active true
    association :group, factory: :socializer_group
    association :activity_member, factory: :socializer_activity_object_person
  end
end
