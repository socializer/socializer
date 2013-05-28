# Read about factories at https://github.com/thoughtbot/factory_girl

# TODO: Redo this factory once the other factories are added
FactoryGirl.define do
  factory :socializer_activity, :class => Socializer::Activity do
    actor_id 1
    activity_object_id 1
    target_id nil
    association :verb, factory: :socializer_verb
  end
end
