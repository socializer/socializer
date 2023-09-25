# frozen_string_literal: true

# Read about factories at https://github.com/thoughtbot/factory_bot

FactoryBot.define do
  factory :activity_object, class: "Socializer::ActivityObject" do
    unread_notifications_count { 0 }
    activitable factory: %i[note], strategy: :create

    factory :activity_object_activity, class: "Socializer::ActivityObject" do
      activitable factory: %i[activity], strategy: :create
    end

    factory :activity_object_circle, class: "Socializer::ActivityObject" do
      activitable factory: %i[circle], strategy: :create
    end

    factory :activity_object_comment, class: "Socializer::ActivityObject" do
      activitable factory: %i[comment], strategy: :create
    end

    factory :activity_object_group, class: "Socializer::ActivityObject" do
      activitable factory: %i[group], strategy: :create
    end

    factory :activity_object_person, class: "Socializer::ActivityObject" do
      activitable factory: %i[person], strategy: :create
    end
  end
end
