# frozen_string_literal: true

class CreateSocializerGroups < ActiveRecord::Migration[4.2]
  def change
    create_table :socializer_groups do |t|
      t.integer  :author_id,    null: false
      t.string   :display_name, null: false
      t.integer  :privacy,      null: false

      t.string   :tagline
      t.text     :about
      t.string   :location

      t.timestamps null: false
    end

    add_index :socializer_groups, :author_id
    add_index :socializer_groups, [:display_name, :author_id], unique: true
    add_index :socializer_groups, :privacy
  end
end
