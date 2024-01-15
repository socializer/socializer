# frozen_string_literal: true

class CreateSocializerPeople < ActiveRecord::Migration[7.1]
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
      t.boolean  :looking_for_friends
      t.boolean  :looking_for_dating
      t.boolean  :looking_for_relationship
      t.boolean  :looking_for_networking
      t.date     :birthdate
      t.integer  :relationship
      t.string   :other_names

      t.timestamps
    end
  end
end
