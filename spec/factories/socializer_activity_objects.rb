# frozen_string_literal: true

# Read about factories at https://github.com/thoughtbot/factory_bot

FactoryBot.define do
  factory :activity_object, class: "Socializer::ActivityObject" do
    unread_notifications_count { 0 }
    association :activitable, factory: :note, strategy: :create

    factory :activity_object_activity, class: "Socializer::ActivityObject" do
      association :activitable, factory: :activity, strategy: :create
    end

    factory :activity_object_circle, class: "Socializer::ActivityObject" do
      association :activitable, factory: :circle, strategy: :create
    end

    factory :activity_object_comment, class: "Socializer::ActivityObject" do
      association :activitable, factory: :comment, strategy: :create
    end

    factory :activity_object_group, class: "Socializer::ActivityObject" do
      association :activitable, factory: :group, strategy: :create
    end

    factory :activity_object_person, class: "Socializer::ActivityObject" do
      association :activitable, factory: :person, strategy: :create
    end
  end
end
