# Read about factories at https://github.com/thoughtbot/factory_girl

# TODO: Redo this factory once the other factories are added
FactoryGirl.define do
  factory :socializer_activity, class: Socializer::Activity do
    association :activity_object, factory: :socializer_activity_object
    association :verb, factory: :socializer_verb
    association :activitable_actor, factory: :socializer_activity_object_person
    association :activitable_object, factory: :socializer_activity_object
    association :activitable_target, factory: :socializer_activity_object_group
  end
end
