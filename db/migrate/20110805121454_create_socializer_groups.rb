# frozen_string_literal: true

class CreateSocializerGroups < ActiveRecord::Migration[7.0]
  def change
    create_table :socializer_groups do |t|
      t.integer  :author_id,    null: false
      t.string   :display_name, null: false
      t.integer  :privacy,      null: false

      t.string   :tagline
      t.text     :about
      t.string   :location

      t.timestamps
    end

    add_index :socializer_groups, :author_id
    add_index :socializer_groups, %i[display_name author_id], unique: true
    add_index :socializer_groups, :privacy
  end
end
