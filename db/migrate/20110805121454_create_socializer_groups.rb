# frozen_string_literal: true

class CreateSocializerGroups < ActiveRecord::Migration[8.1]
  def change
    create_table :socializer_groups do |t|
      t.bigint :author_id, index: true, null: false
      t.string :display_name, null: false
      t.integer :privacy, index: true, null: false

      t.string   :tagline
      t.text     :about
      t.string   :location

      t.timestamps
    end

    add_index :socializer_groups,
              "lower(display_name), author_id",
              unique: true
  end
end
