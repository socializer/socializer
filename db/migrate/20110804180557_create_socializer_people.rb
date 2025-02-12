# frozen_string_literal: true

class CreateSocializerPeople < ActiveRecord::Migration[8.0]
  def change
    create_table :socializer_people do |t|
      t.string   :display_name
      t.string   :email
      t.string   :language
      t.string   :avatar_provider

      # story
      t.string   :tagline
      t.text     :introduction
      t.string   :bragging_rights

      # work
      t.string   :occupation
      t.string   :skills

      # basic information
      t.integer  :gender
      t.boolean  :looking_for_friends, default: false, null: false
      t.boolean  :looking_for_dating, default: false, null: false
      t.boolean  :looking_for_relationship, default: false, null: false
      t.boolean  :looking_for_networking, default: false, null: false
      t.date     :birthdate
      t.integer  :relationship
      t.string   :other_names

      t.timestamps
    end
  end
end
